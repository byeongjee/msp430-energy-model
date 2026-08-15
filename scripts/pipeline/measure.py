"""Measurement steps shared by the training and analysis pipelines."""

from dataclasses import dataclass
from pathlib import Path

from pipeline import log
from pipeline.build import compile_source
from pipeline.config import MAX_CURRENT_DEFAULT, VOLTAGE_DEFAULT, Config, timestamp
from pipeline.files import source_basename
from pipeline.process import run_module


@dataclass
class MeasurementSettings:
    voltage: float = VOLTAGE_DEFAULT
    max_current: float = MAX_CURRENT_DEFAULT
    skip_flash: bool = False


def extract_event_labels(source: Path, output_json: Path) -> None:
    """Extract the event labels of the BENCH() macros in a source file."""
    run_module(
        "benchmarks.extract_bench_labels",
        ["--input", source, "--output", output_json, "--format", "json"],
    )


def measure_and_preprocess(
    cfg: Config,
    source: Path,
    segments_csv: Path,
    event_labels_json: Path,
    defines: str,
    settings: MeasurementSettings,
    raw_csv: Path | None = None,
) -> None:
    """Compile, flash, measure and preprocess one source file.

    measurement.measure flashes through the switchboard-connected ez-FET. The raw
    measurement is removed afterwards unless the caller names a file for it.
    """
    base = source_basename(source)
    keep_raw = raw_csv is not None
    raw_measurement = raw_csv or cfg.temp_dir / f"{base}_raw_{timestamp()}.csv"

    log.step(f"Compiling {base}")
    elf = compile_source(cfg, source, defines)
    log.success(f"Compiled: {elf}")

    log.step(f"Flashing and measuring energy consumption for {base}")
    log.info(f"Voltage: {settings.voltage} V, Max current: {settings.max_current} A")
    run_module(
        "measurement.measure",
        [
            elf,
            "--voltage",
            settings.voltage,
            "--max-current",
            settings.max_current,
            "--outfile",
            raw_measurement,
            *(["--skip-flash"] if settings.skip_flash else []),
        ],
    )
    log.success(f"Raw measurement saved: {raw_measurement}")

    log.step(f"Preprocessing measurements for {base}")
    run_module(
        "measurement.preprocess",
        [
            "--input",
            raw_measurement,
            "--output",
            segments_csv,
            "--event-labels",
            event_labels_json,
        ],
    )
    log.success(f"Segments saved: {segments_csv}")

    if not keep_raw:
        raw_measurement.unlink(missing_ok=True)
        log.info(f"Removed raw data: {raw_measurement}")
