#!/usr/bin/env python3
import argparse, csv, os, subprocess, sys, time, logging, socket
from typing import List, Tuple, Dict
from otii_tcp_client import otii_client
from otii_tcp_client.arc import Arc


# ---------- logging ----------
def setup_logger(level: str = "INFO", logfile: str | None = None) -> logging.Logger:
    logger = logging.getLogger("measure_energy_otii")
    logger.setLevel(getattr(logging, level.upper(), logging.INFO))
    logger.handlers.clear()

    fmt = logging.Formatter(
        fmt="%(asctime)s | %(levelname)-7s | %(message)s", datefmt="%H:%M:%S"
    )
    ch = logging.StreamHandler(sys.stdout)
    ch.setFormatter(fmt)
    logger.addHandler(ch)

    if logfile:
        fh = logging.FileHandler(logfile, mode="a")
        fh.setFormatter(fmt)
        fh.setLevel(logging.DEBUG)  # file gets full detail
        logger.addHandler(fh)

    # Quieten noisy libs unless DEBUG
    if logger.level > logging.DEBUG:
        logging.getLogger("otii_tcp_client").setLevel(logging.WARNING)

    return logger


# ---------- helpers ----------
def sh(cmd: List[str], logger: logging.Logger, timeout=20):
    logger.info("Reset command: %s", " ".join(cmd))
    p = subprocess.run(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, timeout=timeout
    )
    if p.returncode != 0:
        logger.error("Reset command failed (code %s)", p.returncode)
        logger.error("stdout:\n%s", p.stdout.strip())
        logger.error("stderr:\n%s", p.stderr.strip())
        raise RuntimeError(f"Command failed: {' '.join(cmd)}")
    if p.stdout.strip():
        logger.debug("Reset stdout:\n%s", p.stdout.strip())
    if p.stderr.strip():
        logger.debug("Reset stderr:\n%s", p.stderr.strip())
    return p.stdout


def find_first_high_window(events: List[dict]) -> Tuple[float, float]:
    """Return (t_start, t_end) for the first complete high window in sparse GPI1 edges."""
    last = None
    t_start = None
    for e in events:
        v = bool(e["value"])
        if last is False and v is True and t_start is None:
            t_start = e["timestamp"]
        if last is True and v is False and t_start is not None:
            return t_start, e["timestamp"]
        last = v
    return (None, None)


def clamp(v, lo, hi):
    return lo if v < lo else hi if v > hi else v


def get_single_arc_and_id(otii) -> Tuple[Arc, str]:
    """Assume exactly one device is connected. Works with Arc objects or dict metadata."""
    devs = otii.get_devices()
    if not devs:
        raise RuntimeError("No Otii devices found.")
    d0 = devs[0]
    if isinstance(d0, Arc):
        arc = d0
        device_id = getattr(arc, "device_id", getattr(arc, "id", None))
        if not device_id:
            name = getattr(arc, "name", None)
            device_id = otii.get_device_id(name) if name else None
    else:
        name = d0.get("name")
        device_id = otii.get_device_id(name)
        arc = Arc(
            {"device_id": device_id, "name": name, "type": d0.get("type", "Arc")},
            otii.connection,
        )
    if not device_id:
        raise RuntimeError("Could not resolve device_id for the connected Otii device.")
    return arc, device_id


def _wait_for_port(host: str, port: int, timeout: float) -> bool:
    end = time.monotonic() + timeout
    while time.monotonic() < end:
        try:
            with socket.create_connection((host, port), timeout=0.5):
                return True
        except OSError:
            time.sleep(0.1)
    return False


def start_otii_server(logger: logging.Logger) -> subprocess.Popen | None:
    """
    Start otii_server and return the Popen handle.
    Uses OTII_SERVER_BIN from env (loaded via dotenv) or 'otii_server'.
    Waits until the TCP port is accepting connections.
    """
    bin_path = os.getenv("OTII_SERVER_BIN", "otii_server")
    host = os.getenv("OTII_SERVER_HOST", "127.0.0.1")
    port = int(os.getenv("OTII_SERVER_PORT", "1905"))

    logger.info("Starting otii_server: %s (host=%s, port=%d)", bin_path, host, port)
    # Spawn server; keep stdout/stderr to console only at DEBUG to avoid noise
    stdout = subprocess.PIPE if logger.level <= logging.DEBUG else subprocess.DEVNULL
    stderr = subprocess.STDOUT if logger.level <= logging.DEBUG else subprocess.DEVNULL
    proc = subprocess.Popen([bin_path], stdout=stdout, stderr=stderr)

    # Optionally stream logs when DEBUG
    if logger.level <= logging.DEBUG and proc.stdout is not None:
        logger.debug("otii_server started, streaming logs...")

    # Wait for readiness
    if not _wait_for_port(host, port, timeout=10.0):
        try:
            proc.terminate()
        except Exception:
            pass
        raise RuntimeError("otii_server did not become ready on time")

    logger.info("otii_server is ready")
    return proc


def stop_otii_server(proc: subprocess.Popen | None, logger: logging.Logger):
    """Terminate only the server process we started."""
    if not proc:
        return
    logger.info("Stopping otii_server...")
    try:
        proc.terminate()
        try:
            proc.wait(timeout=5)
        except subprocess.TimeoutExpired:
            logger.warning("Force killing otii_server")
            proc.kill()
    except Exception as e:
        logger.debug("While stopping otii_server: %r", e)


# ---------- main ----------
def main():
    ap = argparse.ArgumentParser(
        description="Measure current/power with Otii Ace Pro; export single CSV with per-sample GPI1 and GPI2 edges aligned to nearest sample."
    )
    ap.add_argument("--voltage", type=float, default=3.3)
    ap.add_argument("--max_current", type=float, default=0.01, help="A")
    ap.add_argument("--outfile", default="measurement.csv")
    ap.add_argument("--skip_reset", action="store_true")
    ap.add_argument(
        "--reset_cmd",
        default="mspdebug tilib 'reset' 'exit'",
        help="Shell command to reset target; override for other MCUs",
    )
    ap.add_argument(
        "--gpi_wait_timeout",
        type=float,
        default=30.0,
        help="Timeout (s) waiting for GPI1 rising edge",
    )
    ap.add_argument(
        "--chunk",
        type=int,
        default=50_000,
        help="Analog samples per chunk when exporting",
    )
    ap.add_argument(
        "--log-level",
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
    )
    ap.add_argument("--log-file", default=None, help="Optional log file path")
    args = ap.parse_args()

    logger = setup_logger(args.log_level, args.log_file)
    logger.info("Starting measurement")
    logger.info(
        "Config: V=%.3f V, Imax=%.3f A, outfile=%s, chunk=%d",
        args.voltage,
        args.max_current,
        args.outfile,
        args.chunk,
    )

    server_proc = start_otii_server(logger)

    client = otii_client.OtiiClient()
    otii = client.connect()
    logger.info("Connected to Otii server")

    try:
        project = otii.create_project()
        logger.debug("Project created")

        # --- Single-device assumption ---
        arc, device_id = get_single_arc_and_id(otii)
        logger.info("Using device_id=%s", device_id)

        # Configure channels (keep power off until recording starts)
        arc.add_to_project()

        # Enable switchboard power and expansion port
        arc.enable_5v(True)
        arc.enable_exp_port(True)  # enable expansion port (GPI + GPO)
        arc.set_exp_voltage(5.0)
        for ch in ("mc", "mp", "i1", "i2"):  # current, power, GPI1, GPI2
            arc.enable_channel(ch, True)

        arc.set_main_voltage(args.voltage)
        arc.set_max_current(args.max_current)

        # Ensure main power is off before connecting debugger
        arc.set_main(False)
        time.sleep(0.5)

        # Close switchboard to connect USB for flashing
        # Power-cycle the USB via 5V pin to force macOS re-enumeration
        logger.info("Power-cycling switchboard for USB re-enumeration...")
        arc.set_gpo(2, False)
        arc.enable_5v(False)
        time.sleep(1.0)
        arc.enable_5v(True)
        time.sleep(1.0)
        logger.info("Closing Switchboard (GPO2=True) to connect debugger...")
        arc.set_gpo(2, True)
        time.sleep(10.0)  # Wait for USB to enumerate on macOS

        if not args.skip_reset:
            # Flashing/Reset happens here while relays are closed
            # MSP430 is powered via USB debug — Otii main power is OFF
            sh(["/bin/sh", "-lc", args.reset_cmd], logger)
            logger.info("Target reset issued")
        else:
            logger.info("Target reset skipped")

        # Isolate target: open switchboard, then power on via Otii
        logger.info("Opening Switchboard (GPO2=False) to isolate target...")
        arc.set_gpo(2, False)
        time.sleep(3.0)  # Wait for relays to settle and VCC to decay below POR threshold

        # Now power on via Otii for measurement
        arc.set_main(True)
        logger.info("MAIN enabled; voltage set")

        # We assume that the program has enough delay at the beginning
        # so that we don't miss the first GPI1 edge
        project.start_recording()
        logger.info("Recording started")

        # Live recording handle for event polling
        rec = project.get_last_recording()

        # ---- Detect GPI1 falling edge from events (close the window) ----
        logger.info("Waiting for GPI1 falling edge (to close window)")
        t_fall = None
        last = None
        while True:
            n = rec.get_channel_data_count(device_id, "i1")
            if n > 0:
                ev = rec.get_channel_data(device_id, "i1", n - 1, 1)["values"][0]
                v = bool(ev["value"])
                if v is False and last is True:
                    t_fall = ev["timestamp"]
                    logger.info("Detected GPI1 falling edge at t=%.9f", t_fall)
                    break
                last = v
            time.sleep(0.001)

        project.stop_recording()
        logger.info("Recording stopped")

        # --- Fetch full digital event lists for export logic ---
        def get_digital_events(ch: str) -> List[dict]:
            n = rec.get_channel_data_count(device_id, ch)
            logger.debug("Digital channel '%s': %d events", ch, n)
            if n == 0:
                return []
            d = rec.get_channel_data(device_id, ch, 0, n)
            return d["values"]

        ev_i1 = get_digital_events("i1")  # sparse GPI1 edges with absolute levels
        ev_i2 = get_digital_events("i2")  # sparse GPI2 edges

        # Export window: start at analog start (t0) unless you want to offset it
        t_start = None
        t_end = t_fall

        # --- Analog metadata ---
        mc_count = rec.get_channel_data_count(device_id, "mc")
        mp_count = rec.get_channel_data_count(device_id, "mp")
        logger.info("Analog samples: mc=%d, mp=%d", mc_count, mp_count)
        if mc_count == 0 or mp_count == 0:
            logger.error("No analog data on 'mc'/'mp'")
            raise RuntimeError("No analog data on 'mc'/'mp' channels.")

        hdr = rec.get_channel_data(device_id, "mc", 0, 1)
        t0 = hdr["timestamp"]
        dt = hdr["interval"]
        full_t_end = t0 + dt * (mc_count - 1)

        if t_start is None:
            t_start = t0
        if t_end is None:
            t_end = full_t_end
        logger.info(
            "Window: [%.9f, %.9f] (duration %.6f s)", t_start, t_end, t_end - t_start
        )

        # --- Index helpers ---
        def to_index_floor(t: float) -> int:
            idx = int((t - t0) / dt + 1e-12)
            return clamp(idx, 0, mc_count - 1)

        def to_index_round(t: float) -> int:
            idx = int(round((t - t0) / dt))
            return clamp(idx, 0, mc_count - 1)

        i_start = to_index_floor(t_start)
        i_end = to_index_floor(t_end)
        logger.info(
            "Index window: [%d, %d] (N=%d)", i_start, i_end, i_end - i_start + 1
        )

        # --- Prepare GPI2 edge alignment (nearest-sample) ---
        gpi2_mark: Dict[int, int] = {}
        collisions = 0
        kept = 0
        for e in ev_i2:
            t = e["timestamp"]
            if t < t_start or t > t_end:
                continue
            idx = to_index_round(t)
            if idx in gpi2_mark:
                collisions += 1
            gpi2_mark[idx] = 1 if e["value"] else 0
            kept += 1
        logger.info("GPI2 edges in window: kept=%d, collisions=%d", kept, collisions)

        # --- Prepare streaming GPI1 state (per-sample) ---
        ev_i1_sorted = sorted(ev_i1, key=lambda e: e["timestamp"])
        gpi1_state = 0  # default low if no prior event
        gpi1_idx = 0
        while (
            gpi1_idx < len(ev_i1_sorted)
            and ev_i1_sorted[gpi1_idx]["timestamp"] <= t_start
        ):
            gpi1_state = 1 if ev_i1_sorted[gpi1_idx]["value"] else 0
            gpi1_idx += 1
        gpi1_applied = 0

        # Stream export with per-sample GPI1 and aligned GPI2 markers
        os.makedirs(
            os.path.dirname(os.path.abspath(args.outfile)) or ".", exist_ok=True
        )
        with open(args.outfile, "w", newline="") as f:
            w = csv.writer(f)
            w.writerow(["timestamp_s", "current_A", "power_W", "gpi1", "gpi2"])

            remaining = i_end - i_start + 1
            start = i_start
            chunk = max(1, args.chunk)
            global_idx = i_start  # absolute sample index for gpi2_mark
            rows = 0

            logger.info("Exporting to %s (chunk=%d)", args.outfile, chunk)
            t_export0 = time.monotonic()

            while remaining > 0:
                take = chunk if remaining >= chunk else remaining

                mc = rec.get_channel_data(device_id, "mc", start, take)
                mp = rec.get_channel_data(device_id, "mp", start, take)

                ts0 = mc["timestamp"]
                dtc = mc["interval"]
                vals_mc = mc["values"]
                vals_mp = mp["values"]

                for i in range(len(vals_mc)):
                    ts = ts0 + i * dtc

                    # Advance GPI1 state for any events up to this timestamp
                    while (
                        gpi1_idx < len(ev_i1_sorted)
                        and ev_i1_sorted[gpi1_idx]["timestamp"] <= ts
                    ):
                        gpi1_state = 1 if ev_i1_sorted[gpi1_idx]["value"] else 0
                        gpi1_idx += 1
                        gpi1_applied += 1

                    g2 = gpi2_mark.get(global_idx, "")
                    w.writerow([ts, vals_mc[i], vals_mp[i], gpi1_state, g2])

                    global_idx += 1
                    rows += 1

                start += take
                remaining -= take

                if rows % (chunk * 10) == 0:
                    logger.debug("Exported %d rows...", rows)

        dt_export = time.monotonic() - t_export0
        logger.info(
            "Export complete: %s (rows=%d, time=%.2fs)", args.outfile, rows, dt_export
        )
        logger.info("GPI1 state changes applied during export: %d", gpi1_applied)
        if collisions:
            logger.warning(
                "Note: %d GPI2 edges collided onto the same sample index; kept the last per index.",
                collisions,
            )

        logger.info("Done")

    except Exception as e:
        logging.getLogger("measure_energy_otii").exception("Fatal error")
        raise
    finally:
        try:
            otii.shutdown()
        except Exception:
            logger.exception("Error shutting down Otii client")
            pass
        stop_otii_server(server_proc, logger)


if __name__ == "__main__":
    main()
