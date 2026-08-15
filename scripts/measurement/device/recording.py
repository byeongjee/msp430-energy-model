"""Recording and CSV export for one measured program run.

The recorded window is delimited by GPI1, which the program drives high for
the code under measurement (see ``include/setup.h``); GPI2 carries the event
markers inside that window. The export writes one row per analog sample, with
GPI1 as a per-sample level and GPI2 as edges aligned to the nearest sample.
"""

from __future__ import annotations

import csv
import logging
import time
from collections.abc import Iterator
from contextlib import contextmanager
from pathlib import Path
from typing import Any

from ..errors import DeviceError
from .otii import OtiiSession, _otii_errors

logger = logging.getLogger(__name__)

_GPI1_POLL_SECONDS = 0.001


@contextmanager
def recording(session: OtiiSession) -> Iterator[Any]:
    """Start a recording, and stop it when the block exits.

    The target must still be unpowered here: it may only start running once
    the recording is armed, otherwise the beginning of the run is lost.
    """
    with _otii_errors("recording start"):
        session.project.start_recording()
        rec = session.project.get_last_recording()
    logger.info("Recording started")
    try:
        yield rec
    finally:
        try:
            session.project.stop_recording()
            logger.info("Recording stopped")
        except Exception:
            logger.exception("Error stopping the recording")


def wait_for_gpi1_fall(session: OtiiSession, rec: Any, timeout: float) -> float:
    """Wait for the first GPI1 falling edge and return its timestamp.

    Every event since the previous poll is scanned: looking at the newest
    event only drops edges that arrive within the same poll interval, and
    the falling edge is then waited for forever.
    """
    device_id = session.arc.id
    deadline = time.monotonic() + timeout
    consumed = 0
    level = False

    logger.info("Waiting for the GPI1 falling edge (end of the measured window)")
    while time.monotonic() < deadline:
        with _otii_errors("GPI1 poll"):
            count = rec.get_channel_data_count(device_id, "i1")
            if count > consumed:
                events = rec.get_channel_data(
                    device_id, "i1", consumed, count - consumed
                )["values"]
                consumed = count
            else:
                events = []
        for event in events:
            value = bool(event["value"])
            if level and not value:
                logger.info("GPI1 falling edge at t=%.9f", event["timestamp"])
                return event["timestamp"]
            level = value
        time.sleep(_GPI1_POLL_SECONDS)

    raise DeviceError(
        f"No GPI1 falling edge within {timeout:.0f}s — the target never "
        "completed its measured window"
    )


def _clamp(value: int, low: int, high: int) -> int:
    return low if value < low else min(value, high)


def _digital_events(rec: Any, device_id: str, channel: str) -> list[dict]:
    """Read every edge recorded on a digital channel."""
    with _otii_errors(f"{channel} readback"):
        count = rec.get_channel_data_count(device_id, channel)
        if count == 0:
            return []
        return rec.get_channel_data(device_id, channel, 0, count)["values"]


def export_csv(
    session: OtiiSession,
    rec: Any,
    t_end: float,
    outfile: Path,
    chunk: int,
) -> None:
    """Write the recording up to *t_end* as one CSV row per analog sample."""
    device_id = session.arc.id

    events_gpi1 = _digital_events(rec, device_id, "i1")
    events_gpi2 = _digital_events(rec, device_id, "i2")

    with _otii_errors("analog readback"):
        sample_count = rec.get_channel_data_count(device_id, "mc")
        if sample_count == 0 or rec.get_channel_data_count(device_id, "mp") == 0:
            raise DeviceError("No analog data on the 'mc'/'mp' channels")
        header = rec.get_channel_data(device_id, "mc", 0, 1)
    t0 = header["timestamp"]
    interval = header["interval"]

    def to_index(timestamp: float, round_: bool = False) -> int:
        offset = (timestamp - t0) / interval
        index = round(offset) if round_ else int(offset + 1e-12)
        return _clamp(index, 0, sample_count - 1)

    i_end = to_index(t_end)
    logger.info(
        "Window: [%.9f, %.9f] (%.6f s, %d samples)",
        t0,
        t_end,
        t_end - t0,
        i_end + 1,
    )

    # GPI2 marks single events rather than a window, so each edge is kept as
    # a mark on the sample it lands closest to.
    gpi2_marks: dict[int, int] = {}
    collisions = 0
    for event in events_gpi2:
        if event["timestamp"] < t0 or event["timestamp"] > t_end:
            continue
        index = to_index(event["timestamp"], round_=True)
        if index in gpi2_marks:
            collisions += 1
        gpi2_marks[index] = 1 if event["value"] else 0
    logger.info("GPI2 edges in window: %d (%d collisions)", len(gpi2_marks), collisions)

    gpi1_events = sorted(events_gpi1, key=lambda e: e["timestamp"])
    gpi1_index = 0
    gpi1_level = 0

    outfile.parent.mkdir(parents=True, exist_ok=True)
    with open(outfile, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["timestamp_s", "current_A", "power_W", "gpi1", "gpi2"])

        start = 0
        remaining = i_end + 1
        rows = 0
        export_start = time.monotonic()

        while remaining > 0:
            take = min(chunk, remaining)
            with _otii_errors("analog readback"):
                current = rec.get_channel_data(device_id, "mc", start, take)
                power = rec.get_channel_data(device_id, "mp", start, take)

            for i, (current_a, power_w) in enumerate(
                zip(current["values"], power["values"])
            ):
                timestamp = current["timestamp"] + i * current["interval"]
                while (
                    gpi1_index < len(gpi1_events)
                    and gpi1_events[gpi1_index]["timestamp"] <= timestamp
                ):
                    gpi1_level = 1 if gpi1_events[gpi1_index]["value"] else 0
                    gpi1_index += 1
                writer.writerow(
                    [
                        timestamp,
                        current_a,
                        power_w,
                        gpi1_level,
                        gpi2_marks.get(start + i, ""),
                    ]
                )
                rows += 1

            start += take
            remaining -= take

    logger.info(
        "Exported %d rows to %s (%.2fs)",
        rows,
        outfile,
        time.monotonic() - export_start,
    )
