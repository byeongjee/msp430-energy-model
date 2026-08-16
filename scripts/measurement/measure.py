#!/usr/bin/env python3
"""Measure the energy consumption of one MSP430 program with the Otii Ace Pro.

The ELF is flashed through the switchboard-connected ez-FET and the target is
kept halted under JTAG; the relays then isolate it, which cuts its only supply.
Only after the recording is armed does the Otii main output power the target,
so the program starts from a clean POR that cannot precede the recording.

Writes one CSV row per analog sample, from the start of the recording to the
first GPI1 falling edge (see ``docs/measurement_setup.md``).
"""

from __future__ import annotations

import argparse
import logging
import sys
from pathlib import Path

from measurement.device.flash import flash_and_hold
from measurement.device.otii import (
    configure_supply,
    connect_debugger,
    isolate_target,
    otii_session,
)
from measurement.device.recording import export_csv, recording, wait_for_gpi1_fall
from measurement.errors import MeasurementError
from measurement.log import setup_logging

logger = logging.getLogger("measurement.measure")

_FLASH_TIMEOUT_SECONDS = 30


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Measure the energy consumption of one MSP430 program."
    )
    parser.add_argument("elf", help="Path to the ELF binary to measure")
    parser.add_argument("--voltage", type=float, default=3.3)
    parser.add_argument("--max-current", type=float, default=0.01, help="A")
    parser.add_argument("--outfile", default="measurement.csv")
    parser.add_argument(
        "--skip-flash",
        action="store_true",
        help="Measure the program already on the target instead of flashing",
    )
    parser.add_argument(
        "--gpi-wait-timeout",
        type=float,
        # Training batches run for minutes at NUM_REPEAT=30 (each event pulse
        # carries 0.2 s of guard delay, cos/sin helpers longer still).
        default=1800.0,
        help="Timeout (s) waiting for the GPI1 falling edge",
    )
    parser.add_argument(
        "--chunk",
        type=int,
        default=50_000,
        help="Analog samples per chunk when exporting",
    )
    parser.add_argument(
        "--log-level",
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
    )
    return parser.parse_args()


def measure(args: argparse.Namespace) -> None:
    elf = Path(args.elf)
    if not args.skip_flash and not elf.is_file():
        raise MeasurementError(f"ELF file not found: {elf}")

    with otii_session() as session:
        configure_supply(session, args.voltage, args.max_current)

        if args.skip_flash:
            # The relays are already open after session setup; this only
            # guarantees the settle time before the target is powered.
            logger.info("Skipping flash: measuring the program on the target")
            isolate_target(session)
        else:
            connect_debugger(session)
            flash = flash_and_hold(elf, _FLASH_TIMEOUT_SECONDS)
            # Cut the supply while the target is still halted, so it never
            # runs on the debugger's 3V3 rail. The mspdebug session dies with
            # the cut SBW lines; abort() discards it, and must run even when
            # isolate_target fails or the leaked session keeps the ez-FET
            # claimed for every following measurement.
            try:
                isolate_target(session)
            finally:
                flash.abort()

        with recording(session) as rec:
            session.arc.set_main(True)
            logger.info("Main output enabled")
            t_end = wait_for_gpi1_fall(session, rec, args.gpi_wait_timeout)

        export_csv(session, rec, t_end, Path(args.outfile), args.chunk)


def main() -> None:
    args = parse_args()
    setup_logging(args.log_level)
    try:
        measure(args)
    except MeasurementError as exc:
        logger.error("%s", exc)
        sys.exit(1)


if __name__ == "__main__":
    main()
