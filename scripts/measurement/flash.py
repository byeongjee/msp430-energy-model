"""Flash an ELF to the MSP430 through the switchboard-connected ez-FET.

Ends where a measurement run does: the target is isolated from the debugger
and unpowered, so the program starts only when something powers the board
again (see ``docs/measurement_setup.md``).
"""

from __future__ import annotations

import argparse
import logging
import sys
from pathlib import Path

from measurement.device.flash import flash_and_hold
from measurement.device.otii import connect_debugger, isolate_target, otii_session
from measurement.errors import MeasurementError
from measurement.log import setup_logging

logger = logging.getLogger("measurement.flash")

_FLASH_TIMEOUT_SECONDS = 30


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Flash an ELF binary to the MSP430 target."
    )
    parser.add_argument("elf", help="Path to the ELF binary to flash")
    parser.add_argument(
        "--log-level",
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
    )
    return parser.parse_args()


def flash_elf(elf: Path) -> None:
    if not elf.is_file():
        raise MeasurementError(f"ELF file not found: {elf}")

    with otii_session() as session:
        connect_debugger(session)
        flash = flash_and_hold(elf, _FLASH_TIMEOUT_SECONDS)
        # Isolate while still halted, then discard the session: the target
        # never runs on the debugger's 3V3 rail.
        try:
            isolate_target(session)
        finally:
            flash.abort()
    logger.info("Flashed %s", elf)


def main() -> None:
    args = parse_args()
    setup_logging(args.log_level)
    try:
        flash_elf(Path(args.elf))
    except MeasurementError as exc:
        logger.error("%s", exc)
        sys.exit(1)


if __name__ == "__main__":
    main()
