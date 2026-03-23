#!/usr/bin/env python3
"""Flash an ELF binary to MSP430 via mspdebug, with Otii Switchboard GPO2 control."""
import argparse, os, subprocess, sys, time, logging, socket

from otii_tcp_client import otii_client
from otii_tcp_client.arc import Arc


# ---------- logging ----------
def setup_logger(level: str = "INFO") -> logging.Logger:
    logger = logging.getLogger("flash_otii")
    logger.setLevel(getattr(logging, level.upper(), logging.INFO))
    logger.handlers.clear()

    fmt = logging.Formatter(
        fmt="%(asctime)s | %(levelname)-7s | %(message)s", datefmt="%H:%M:%S"
    )
    ch = logging.StreamHandler(sys.stdout)
    ch.setFormatter(fmt)
    logger.addHandler(ch)

    if logger.level > logging.DEBUG:
        logging.getLogger("otii_tcp_client").setLevel(logging.WARNING)

    return logger


# ---------- helpers ----------
def get_single_arc_and_id(otii):
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
    bin_path = os.getenv("OTII_SERVER_BIN", "otii_server")
    host = os.getenv("OTII_SERVER_HOST", "127.0.0.1")
    port = int(os.getenv("OTII_SERVER_PORT", "1905"))

    logger.info("Starting otii_server: %s (host=%s, port=%d)", bin_path, host, port)
    stdout = subprocess.PIPE if logger.level <= logging.DEBUG else subprocess.DEVNULL
    stderr = subprocess.STDOUT if logger.level <= logging.DEBUG else subprocess.DEVNULL
    proc = subprocess.Popen([bin_path], stdout=stdout, stderr=stderr)

    if not _wait_for_port(host, port, timeout=10.0):
        try:
            proc.terminate()
        except Exception:
            pass
        raise RuntimeError("otii_server did not become ready on time")

    logger.info("otii_server is ready")
    return proc


def stop_otii_server(proc: subprocess.Popen | None, logger: logging.Logger):
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
        description="Flash an ELF binary to MSP430 with Otii Switchboard GPO2 control."
    )
    ap.add_argument("elf", help="Path to the ELF binary to flash")
    ap.add_argument("--voltage", type=float, default=3.3)
    ap.add_argument("--max-current", type=float, default=0.01, help="A")
    ap.add_argument(
        "--flash-cmd",
        default=None,
        help="Override flash command (default: mspdebug tilib 'prog <elf>' 'exit')",
    )
    ap.add_argument(
        "--log-level",
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
    )
    args = ap.parse_args()

    if not os.path.isfile(args.elf):
        print(f"Error: ELF file not found: {args.elf}", file=sys.stderr)
        sys.exit(1)

    flash_cmd = args.flash_cmd or f"mspdebug tilib 'prog {args.elf}' 'exit'"

    logger = setup_logger(args.log_level)
    logger.info("Flashing %s", args.elf)

    server_proc = start_otii_server(logger)

    client = otii_client.OtiiClient()
    otii = client.connect()
    logger.info("Connected to Otii server")

    project = otii.create_project()
    try:
        arc, device_id = get_single_arc_and_id(otii)
        logger.info("Using device_id=%s", device_id)

        arc.add_to_project()

        # Power the switchboard (5V on expansion port)
        arc.enable_5v(True)
        arc.set_exp_voltage(5.0)
        arc.enable_exp_port(True)

        arc.set_main_voltage(args.voltage)
        arc.set_max_current(args.max_current)

        # Ensure main power is off before connecting debugger
        arc.set_main(False)
        time.sleep(0.5)

        # Power-cycle USB via 5V pin to force macOS re-enumeration
        logger.info("Power-cycling switchboard for USB re-enumeration...")
        arc.set_gpo(2, False)
        arc.enable_5v(False)
        time.sleep(1.0)
        arc.enable_5v(True)
        time.sleep(1.0)

        # Connect debugger (GPO2 HIGH)
        logger.info("Closing Switchboard (GPO2=True) to connect debugger...")
        arc.set_gpo(2, True)
        time.sleep(10.0)  # Wait for USB enumeration on macOS

        # Flash
        logger.info("Flash command: %s", flash_cmd)
        p = subprocess.run(
            ["/bin/sh", "-lc", flash_cmd],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, timeout=30,
        )
        if p.returncode != 0:
            logger.error("Flash failed (code %s)", p.returncode)
            logger.error("stdout:\n%s", p.stdout.strip())
            logger.error("stderr:\n%s", p.stderr.strip())
            raise RuntimeError(f"Flash command failed: {flash_cmd}")
        logger.info("Flash succeeded")
        if p.stdout.strip():
            logger.debug("stdout:\n%s", p.stdout.strip())

        # Isolate target (GPO2 LOW)
        logger.info("Opening Switchboard (GPO2=False) to isolate target...")
        arc.set_gpo(2, False)
        time.sleep(0.5)

        # Power off
        arc.set_main(False)
        logger.info("MAIN disabled")

    finally:
        try:
            otii.close_project(project)
        except Exception:
            pass
        stop_otii_server(server_proc, logger)

    logger.info("Done")


if __name__ == "__main__":
    main()
