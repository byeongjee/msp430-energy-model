"""Training pipeline: measure → preprocess → train."""

from dataclasses import dataclass, field
from pathlib import Path

from pipeline import log
from pipeline.build import compile_and_disasm
from pipeline.config import PROJECT_ROOT, Config, timestamp
from pipeline.files import expand_required, match_files_by_basename, source_basename
from pipeline.measure import (
    MeasurementSettings,
    extract_event_labels,
    measure_and_preprocess,
)
from pipeline.process import run_julia


@dataclass
class TrainOptions:
    files: str
    training_segments_csv: str = ""
    params: Path | None = None
    tag: str = ""
    timestamp: str = ""
    max_steps: int | None = None
    n_samples: int | None = None
    model: str = "mean_per_addressing_mode"
    inference: str = "map"
    defines: str = ""
    keep_intermediates: bool = False
    intercept_special_calls: bool = False
    measurement: MeasurementSettings = field(default_factory=MeasurementSettings)


def julia_flags(options: TrainOptions) -> list[str]:
    """Flags shared by the Julia train and estimate commands."""
    flags: list[str] = []
    if options.max_steps is not None:
        flags += ["--max-steps", str(options.max_steps)]
    if options.n_samples is not None:
        flags += ["--n-samples", str(options.n_samples)]
    if options.model:
        flags += ["--model", options.model]
    if options.inference:
        flags += ["--inference", options.inference]
    return flags


def run(cfg: Config, options: TrainOptions) -> Path:
    """Run the training pipeline and return the parameter file it produced."""
    train_files = expand_required(options.files, "training files")
    log.info(f"Found {len(train_files)} training file(s) from pattern: {options.files}")

    cfg.temp_dir.mkdir(parents=True, exist_ok=True)
    stamp = options.timestamp or timestamp()
    suffix = f"{options.tag}_{stamp}" if options.tag else stamp

    segments_csvs: list[Path] = []
    temp_segments = False
    matches: list[Path | None] = [None] * len(train_files)
    if options.training_segments_csv:
        log.info("Matching training segments CSVs by basename...")
        matches = match_files_by_basename(
            train_files, options.training_segments_csv, "training segments CSV"
        )

    for train_file, match in zip(train_files, matches):
        base = source_basename(train_file)
        if match is None:
            segments_csvs.append(cfg.temp_dir / f"{base}_segments_{stamp}.csv")
            temp_segments = True
        else:
            log.info(f"  Matched segments CSV for {base}: {match}")
            segments_csvs.append(match)

    log.info(f"Training files: {len(train_files)}")
    for index, train_file in enumerate(train_files, start=1):
        log.info(f"  [{index}] {train_file}")

    params_file = options.params
    temp_params = params_file is None
    if params_file is None:
        params_file = cfg.temp_dir / f"params_{suffix}.json"
        log.info(f"Using temporary params file: {params_file}")

    # An existing params file that the caller named explicitly is reused as-is.
    skip_training = not temp_params and params_file.is_file()
    if skip_training:
        log.info(f"Using existing params: {params_file} (training skipped)")

    event_labels: list[Path] = []
    for train_file in train_files:
        base = source_basename(train_file)
        labels_json = cfg.temp_dir / f"labels_{base}_{stamp}.json"
        log.info(f"Extracting event labels from {train_file}...")
        extract_event_labels(train_file, labels_json)
        event_labels.append(labels_json)

    if options.defines:
        log.info(f"Using compiler defines: {options.defines}")

    try:
        log.step("TRAINING PIPELINE START")
        log.info(f"Training files: {len(train_files)}")
        for train_file in train_files:
            log.info(f"  - {train_file}")
        log.info(f"Output params file: {params_file}")

        processed = 0
        skipped = 0
        for index, train_file in enumerate(train_files):
            segments_csv = segments_csvs[index]
            log.info("")
            log.info(
                f"Processing training file {index + 1}/{len(train_files)}: {train_file}"
            )

            if segments_csv.is_file():
                log.info(
                    f"✓ Segments CSV already exists: {segments_csv} - SKIPPING measurement and preprocessing"
                )
                skipped += 1
                continue

            measure_and_preprocess(
                cfg,
                train_file,
                segments_csv,
                event_labels[index],
                options.defines,
                options.measurement,
            )
            processed += 1

        log.info("")
        log.info(
            f"Processing summary: {processed} processed, {skipped} skipped (already have segments CSV)"
        )
        print()
        log.info("==> Hardware no longer required - remaining steps can run offline")
        print()

        # Recompile every file: measurement is skipped when segments already exist.
        log.step("Compiling and disassembling training files")
        asm_files = []
        data_files = []
        for train_file in train_files:
            asm_file, data_file = compile_and_disasm(cfg, train_file, options.defines)
            asm_files.append(asm_file)
            data_files.append(data_file)

        if skip_training:
            log.step(f"Training SKIPPED (using existing params: {params_file})")
        else:
            log.step(f"Training energy model from {len(train_files)} file(s)")
            run_julia(
                PROJECT_ROOT,
                "train",
                [
                    "--asm",
                    *asm_files,
                    "--data-dump",
                    *data_files,
                    "--data",
                    *segments_csvs,
                    "--output",
                    params_file,
                    *julia_flags(options),
                    *(
                        ["--intercept-special-calls"]
                        if options.intercept_special_calls
                        else []
                    ),
                ],
            )
            log.success(f"Model trained: {params_file}")

        log.step("TRAINING PIPELINE COMPLETE")
        log.success("Training completed successfully!")
        print()
        log.info("Output files:")
        if not temp_segments:
            print(f"  - Training Segments CSVs ({len(segments_csvs)} files):")
            for segments_csv in segments_csvs:
                print(f"      {segments_csv}")
        if not temp_params:
            print(f"  - Parameters: {params_file}")
    finally:
        for labels_json in event_labels:
            labels_json.unlink(missing_ok=True)
        if not options.keep_intermediates:
            if temp_segments:
                for segments_csv in segments_csvs:
                    if segments_csv.is_file():
                        log.info(
                            f"Cleaning up temporary training segments CSV: {segments_csv}"
                        )
                        segments_csv.unlink()
            if temp_params and params_file.is_file():
                log.info(f"Cleaning up temporary params file: {params_file}")
                params_file.unlink()

    return params_file
