"""Energy distribution analysis: flash → measure → preprocess → analyze."""

from dataclasses import dataclass, field
from pathlib import Path

from pipeline import defines as defines_util
from pipeline import log
from pipeline.config import Config, timestamp
from pipeline.errors import PipelineError
from pipeline.files import expand_required, match_files_by_basename, source_basename
from pipeline.measure import (
    MeasurementSettings,
    extract_event_labels,
    measure_and_preprocess,
)
from pipeline.process import run_module


@dataclass
class AnalyzeOptions:
    files: str
    segments_csv: str = ""
    tag: str = ""
    defines: str = ""
    report_dir: Path | None = None
    measurement: MeasurementSettings = field(default_factory=MeasurementSettings)


def _combine_segments(segment_files: list[Path], combined: Path) -> None:
    """Concatenate segment CSVs, keeping the header of the first file only."""
    with combined.open("wb") as output:
        for index, segments_csv in enumerate(segment_files):
            content = segments_csv.read_bytes()
            if index > 0:
                _, _, content = content.partition(b"\n")
            output.write(content)


def run(cfg: Config, options: AnalyzeOptions) -> None:
    files = expand_required(options.files, "files")
    log.info(f"Found {len(files)} file(s) from pattern: {options.files}")

    if options.defines:
        log.info(f"Using compiler defines: {options.defines}")

    cfg.temp_dir.mkdir(parents=True, exist_ok=True)
    cfg.build_dir.mkdir(parents=True, exist_ok=True)
    stamp = timestamp()

    report_dir = (options.report_dir or cfg.report_dir) / "analyze_distribution"
    report_dir /= options.tag or stamp
    report_dir.mkdir(parents=True, exist_ok=True)

    matches: list[Path | None] = [None] * len(files)
    if options.segments_csv:
        log.info("Matching segments CSVs by basename...")
        matches = match_files_by_basename(files, options.segments_csv, "segments CSV")

    segment_files: list[Path] = []
    for file, match in zip(files, matches):
        base = source_basename(file)
        if match is None:
            segment_files.append(cfg.temp_dir / f"segments_{base}_{stamp}.csv")
        else:
            log.info(f"  Matched segments CSV for {base}: {match}")
            segment_files.append(match)

    log.step("ANALYZE DISTRIBUTION START")
    log.info(f"Files: {len(files)}")
    for file in files:
        log.info(f"  - {file}")
    log.info(f"Report directory: {report_dir}")

    log.step("Extracting event labels from C source files")
    event_labels: list[Path] = []
    for file in files:
        labels_json = cfg.temp_dir / f"labels_{source_basename(file)}_{stamp}.json"
        log.info(f"Extracting labels from {file}...")
        extract_event_labels(file, labels_json)
        event_labels.append(labels_json)

    try:
        for index, file in enumerate(files):
            segments_csv = segment_files[index]
            log.info("")
            log.info(f"Processing file {index + 1}/{len(files)}: {file}")

            if segments_csv.is_file():
                log.info(
                    f"✓ Segments CSV already exists: {segments_csv} - SKIPPING measurement"
                )
                continue

            measure_and_preprocess(
                cfg,
                file,
                segments_csv,
                event_labels[index],
                options.defines,
                options.measurement,
            )

        log.step(f"Combining segments from {len(files)} file(s)")
        combined_segments_csv = report_dir / "segments.csv"
        _combine_segments(segment_files, combined_segments_csv)
        log.success(f"Segments saved: {combined_segments_csv}")

        for segments_csv in segment_files:
            if cfg.temp_dir in segments_csv.parents:
                segments_csv.unlink(missing_ok=True)
                log.info(f"Cleaned up temporary segments file: {segments_csv}")

        num_repeat = defines_util.extract(options.defines, "NUM_REPEAT")
        if not num_repeat:
            raise PipelineError(
                "NUM_REPEAT not found in the defines. Please add NUM_REPEAT=<value> to --defines"
            )

        total_segments = len(combined_segments_csv.read_text().splitlines()) - 1
        log.info(f"Total segments: {total_segments}")
        log.info(f"Total events: {total_segments // int(num_repeat)}")

        log.step("Generating combined distribution analysis report")
        run_module(
            "reports.generate_distribution_report",
            [
                "--segments-csv",
                combined_segments_csv,
                "--num-repeat",
                num_repeat,
                "--report-dir",
                report_dir,
                "--file-name",
                ", ".join(str(file) for file in files),
            ],
        )
        log.success("Distribution analysis report generated")

        log.step("ANALYSIS COMPLETE")
        log.success("All steps completed successfully!")
        print()
        log.info("Output files:")
        print(f"  - Report directory: {report_dir}")
        print(f"  - Markdown Report: {report_dir}/distribution_analysis.md")
        print(f"  - Segments CSV: {combined_segments_csv}")
        print(f"  - Summary CSV: {report_dir}/distribution_summary.csv")
        print(f"  - Distribution plots: {report_dir}/event_*_distribution.png")
        print()
        log.info(f"Files analyzed: {len(files)}")
        for index, file in enumerate(files, start=1):
            print(f"  {index}. {file}")
    finally:
        for labels_json in event_labels:
            labels_json.unlink(missing_ok=True)
