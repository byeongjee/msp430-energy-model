"""Check that the switchboard relays connect and isolate the ez-FET.

Closes the relays and expects mspdebug to reach the target, then opens them
and expects it to fail. That is the wiring contract every measurement run
depends on: a target that stays reachable with the relays open is still tied
to the debugger and its measurements are distorted.
"""

from __future__ import annotations

import logging
import subprocess
import sys

from measurement.device.otii import connect_debugger, isolate_target, otii_session
from measurement.errors import MeasurementError
from measurement.log import setup_logging

logger = logging.getLogger("measurement.check_switchboard")

_MSPDEBUG_TIMEOUT_SECONDS = 30


def debugger_reaches_target() -> bool:
    """Return whether mspdebug can open a session with the target."""
    try:
        result = subprocess.run(
            ["mspdebug", "tilib", "exit"],
            capture_output=True,
            check=False,
            text=True,
            timeout=_MSPDEBUG_TIMEOUT_SECONDS,
        )
    except subprocess.TimeoutExpired:
        return False
    except FileNotFoundError as exc:
        raise MeasurementError("mspdebug not found on PATH") from exc
    return result.returncode == 0


def main() -> None:
    setup_logging("INFO")
    try:
        with otii_session() as session:
            connect_debugger(session)
            closed_ok = debugger_reaches_target()
            logger.info(
                "Relays closed: target %s",
                "reachable (expected)" if closed_ok else "UNREACHABLE (unexpected)",
            )

            isolate_target(session)
            open_ok = not debugger_reaches_target()
            logger.info(
                "Relays open: target %s",
                "isolated (expected)" if open_ok else "STILL REACHABLE (unexpected)",
            )
            if closed_ok and open_ok:
                logger.info("Switchboard wiring OK")
                return
    except MeasurementError as exc:
        logger.error("%s", exc)
        sys.exit(1)

    logger.error("Switchboard wiring is wrong — see docs/measurement_setup.md")
    sys.exit(1)


if __name__ == "__main__":
    main()
