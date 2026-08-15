"""Otii Ace Pro control for energy measurement runs.

Supplies the MSP430FR5994 target from the Otii main output while a Qoitech
Switchboard, driven from an expansion-port GPO, connects or isolates the
ez-FET debugger's SBW and 3V3 jumper lines. The target must be isolated from
the debugger while it is measured: the debugger's pins otherwise stay on the
target rail and leak through their ESD protection diodes. The switchboard's
USB interface is not used — the ez-FET keeps host USB at all times, only its
jumper lines to the target side are switched. See
``docs/measurement_setup.md``.

Mirrors ``ckpt/device/otii.py`` in the bao repository; keep the shared
functions in sync.

Requires the ``otii-tcp-client`` package and the ``otii_server`` binary (path
via the ``OTII_SERVER_BIN`` environment variable).
"""

from __future__ import annotations

import logging
import os
import socket
import subprocess
import time
from collections.abc import Iterator
from contextlib import contextmanager
from dataclasses import dataclass
from typing import Any

from ..errors import DeviceError

logger = logging.getLogger(__name__)

# Switchboard relay control (GPO number on the expansion port).
_RELAY_GPO = 2
# Settle time after closing the relays before mspdebug can talk to the target.
_DEBUGGER_SETTLE_SECONDS = 3.0
# Settle time after opening the relays: VCC must decay below POR threshold.
_ISOLATION_SETTLE_SECONDS = 3.0

# The switchboard relay logic is powered from the +5V pin and driven at the
# expansion-port digital voltage.
_EXP_VOLTAGE = 5.0

# Main current, main power, GPI1 (measured window), GPI2 (event markers).
_MEASUREMENT_CHANNELS = ("mc", "mp", "i1", "i2")

_SERVER_READY_TIMEOUT_SECONDS = 10.0


@dataclass
class OtiiSession:
    """A connected Otii device, ready for measurement runs."""

    otii: Any
    arc: Any
    project: Any


def _import_otii():
    try:
        from otii_tcp_client import otii_client
        from otii_tcp_client.arc import Arc
    except ImportError as exc:
        raise DeviceError(
            "otii-tcp-client package not installed. Install with: uv sync"
        ) from exc
    return otii_client, Arc


@contextmanager
def _otii_errors(step: str) -> Iterator[None]:
    """Translate otii-tcp-client errors into DeviceError.

    Every client call raises Otii_Exception (or a socket error) on failure;
    without translation those unwind past the caller's DeviceError handler
    and abort a whole measurement batch.
    """
    try:
        from otii_tcp_client import otii_exception

        errors: tuple[type[Exception], ...] = (otii_exception.Otii_Exception, OSError)
    except ImportError:
        errors = (OSError,)
    try:
        yield
    except errors as exc:
        raise DeviceError(f"Otii {step} failed: {exc}") from exc


def _wait_for_port(host: str, port: int, timeout: float) -> bool:
    end = time.monotonic() + timeout
    while time.monotonic() < end:
        try:
            with socket.create_connection((host, port), timeout=0.5):
                return True
        except OSError:
            time.sleep(0.1)
    return False


def _start_server() -> subprocess.Popen:
    bin_path = os.environ.get("OTII_SERVER_BIN", "otii_server")
    host = os.environ.get("OTII_SERVER_HOST", "127.0.0.1")
    port = int(os.environ.get("OTII_SERVER_PORT", "1905"))

    logger.info("Starting otii_server: %s (%s:%d)", bin_path, host, port)
    try:
        proc = subprocess.Popen(
            [bin_path], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )
    except FileNotFoundError as exc:
        raise DeviceError(
            f"otii_server binary not found: {bin_path!r} "
            "(set OTII_SERVER_BIN to its path)"
        ) from exc

    if not _wait_for_port(host, port, _SERVER_READY_TIMEOUT_SECONDS):
        proc.terminate()
        raise DeviceError(
            f"otii_server did not become ready within "
            f"{_SERVER_READY_TIMEOUT_SECONDS:.0f}s on {host}:{port}"
        )
    return proc


def _stop_server(proc: subprocess.Popen) -> None:
    proc.terminate()
    try:
        proc.wait(timeout=5)
    except subprocess.TimeoutExpired:
        logger.warning("Force killing otii_server")
        proc.kill()


def _single_arc(otii: Any, arc_cls: Any) -> Any:
    """Resolve the single connected Otii device to an Arc object."""
    devices = otii.get_devices()
    if not devices:
        raise DeviceError("No Otii devices found")
    first = devices[0]
    if isinstance(first, arc_cls):
        return first
    name = first.get("name")
    return arc_cls(
        {
            "device_id": otii.get_device_id(name),
            "name": name,
            "type": first.get("type", "Arc"),
        },
        otii.connection,
    )


@contextmanager
def otii_session() -> Iterator[OtiiSession]:
    """Start otii_server, connect, and configure the device for measurement.

    On exit: main power off, switchboard relays opened, server stopped.
    """
    otii_client, arc_cls = _import_otii()
    server = _start_server()
    otii = None
    arc = None
    try:
        with _otii_errors("session setup"):
            otii = otii_client.OtiiClient().connect()
            logger.info("Connected to Otii server")

            project = otii.create_project()
            arc = _single_arc(otii, arc_cls)
            arc.add_to_project()

            arc.set_main(False)
            arc.enable_exp_port(True)
            arc.set_exp_voltage(_EXP_VOLTAGE)
            # Force the relays open before powering their coils: a crashed
            # previous session may have left the GPO latched high.
            arc.set_gpo(_RELAY_GPO, False)
            arc.enable_5v(True)  # powers the switchboard relays

        yield OtiiSession(otii=otii, arc=arc, project=project)
    finally:
        # Each cleanup step runs even if the previous one failed, and none
        # may mask the original error — hence the broad excepts.
        if arc is not None:
            try:
                arc.set_main(False)
            except Exception:
                logger.exception("Error switching off Otii main power")
            try:
                arc.set_gpo(_RELAY_GPO, False)
                logger.info(
                    "Switchboard relays left open — the ez-FET is disconnected "
                    "until the next run closes them"
                )
            except Exception:
                logger.exception("Error opening switchboard relays")
        if otii is not None:
            try:
                otii.shutdown()
            except Exception:
                logger.exception("Error shutting down Otii client")
        _stop_server(server)


def configure_supply(session: OtiiSession, voltage: float, max_current: float) -> None:
    """Set the target supply and enable the recorded channels. Leaves main off."""
    with _otii_errors("supply setup"):
        for channel in _MEASUREMENT_CHANNELS:
            session.arc.enable_channel(channel, True)
        session.arc.set_main_voltage(voltage)
        session.arc.set_max_current(max_current)
    logger.info("Supply configured: %.3f V, max %.3f A", voltage, max_current)


def connect_debugger(session: OtiiSession) -> None:
    """Close the switchboard relays: SBW + 3V3 connect the ez-FET to the target.

    Main power is forced off first — the target must never see the Otii
    supply and the debugger's 3V3 rail at the same time.
    """
    with _otii_errors("relay close"):
        session.arc.set_main(False)
        logger.info("Closing switchboard relays (debugger connected)")
        session.arc.set_gpo(_RELAY_GPO, True)
    time.sleep(_DEBUGGER_SETTLE_SECONDS)


def isolate_target(session: OtiiSession) -> None:
    """Open the switchboard relays, cutting SBW and 3V3 to the target."""
    with _otii_errors("relay open"):
        logger.info("Opening switchboard relays (target isolated)")
        session.arc.set_gpo(_RELAY_GPO, False)
    time.sleep(_ISOLATION_SETTLE_SECONDS)
