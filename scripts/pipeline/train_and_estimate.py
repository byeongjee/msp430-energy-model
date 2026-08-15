"""Full pipeline: train → measure the estimation program → estimate → compare."""

from dataclasses import dataclass, field
from pathlib import Path

from pipeline import defines as defines_util
from pipeline import log, train
from pipeline.build import compile_and_disasm
from pipeline.config import PROJECT_ROOT, Config, timestamp
from pipeline.errors import PipelineError
from pipeline.files import expand_required, match_single_file, source_basename
from pipeline.measure import (
    MeasurementSettings,
    extract_event_labels,
    measure_and_preprocess,
)
from pipeline.process import run_julia, run_module


@dataclass
class TrainAndEstimateOptions:
    train_files: str
    estimate_file: Path
    training_segments_csv: str = ""
    test_segments_csv: str = ""
    params: Path | None = None
    tag: str = ""
    max_steps: int | None = None
    n_samples: int | None = None
    model: str = "mean_per_addressing_mode"
    inference: str = "importance-sampling"
    train_defines: str = ""
    estimate_defines: str = ""
    report_dir: Path | None = None
    keep_intermediates: bool = False
    intercept_special_calls: bool = False
    measurement: MeasurementSettings = field(default_factory=MeasurementSettings)


def run(cfg: Config, options: TrainAndEstimateOptions) -> None:
    train_files = expand_required(options.train_files, "training files")
    log.info(
        f"Found {len(train_files)} training file(s) from pattern: {options.train_files}"
    )

    if not options.estimate_file.is_file():
        raise PipelineError(f"Estimation file not found: {options.estimate_file}")

    cfg.temp_dir.mkdir(parents=True, exist_ok=True)
    stamp = timestamp()
    suffix = f"{options.tag}_{stamp}" if options.tag else stamp
    report_dir = (options.report_dir or cfg.report_dir) / (options.tag or stamp)

    log.info(f"Training files: {len(train_files)}")
    for index, train_file in enumerate(train_files, start=1):
        log.info(f"  [{index}] {train_file}")

    params_file = options.params
    temp_params = params_file is None
    if params_file is None:
        params_file = cfg.temp_dir / f"params_{suffix}.json"
        log.info(f"Using temporary params file: {params_file}")

    estimated_stats_json = cfg.temp_dir / f"estimated_stats_{suffix}.json"

    temp_test_segments = not options.test_segments_csv
    if temp_test_segments:
        test_segments_csv = cfg.temp_dir / f"measured_segments_{suffix}.csv"
        log.info(f"Using temporary test segments CSV: {test_segments_csv}")
    elif any(wildcard in options.test_segments_csv for wildcard in "*?{"):
        log.info(f"Expanding test segments CSV pattern: {options.test_segments_csv}")
        test_segments_csv = match_single_file(
            options.test_segments_csv, "test segments CSV"
        )
        log.info(f"Matched test segments CSV: {test_segments_csv}")
    else:
        test_segments_csv = Path(options.test_segments_csv)

    log.info(f"Report will be saved to: {report_dir}")

    estimate_base = source_basename(options.estimate_file)
    estimate_labels_json = cfg.temp_dir / f"labels_{estimate_base}_{stamp}.json"
    log.info(f"Extracting event labels from {options.estimate_file}...")
    extract_event_labels(options.estimate_file, estimate_labels_json)

    if options.estimate_defines:
        log.info(f"Using estimation compiler defines: {options.estimate_defines}")

    skip_training = not temp_params and params_file.is_file()
    if skip_training:
        log.info(f"Using existing params: {params_file} (training skipped)")

    skip_estimation_measurement = not temp_test_segments and test_segments_csv.is_file()
    if skip_estimation_measurement:
        log.info(
            f"Using existing test segments CSV: {test_segments_csv} - skipping test measurement and preprocessing"
        )

    try:
        log.step("PIPELINE START")
        log.info(f"Training files: {len(train_files)}")
        for train_file in train_files:
            log.info(f"  - {train_file}")
        log.info(f"Estimate file: {options.estimate_file}")
        log.info(f"Report directory: {report_dir}")

        if skip_training:
            log.step(
                f"Training pipeline SKIPPED (using existing params: {params_file})"
            )
        else:
            log.step("Training pipeline")
            train.run(
                cfg,
                train.TrainOptions(
                    files=options.train_files,
                    training_segments_csv=options.training_segments_csv,
                    params=params_file,
                    tag=options.tag,
                    timestamp=stamp,
                    max_steps=options.max_steps,
                    n_samples=options.n_samples,
                    model=options.model,
                    inference=options.inference,
                    defines=options.train_defines,
                    keep_intermediates=options.keep_intermediates,
                    intercept_special_calls=options.intercept_special_calls,
                    measurement=options.measurement,
                ),
            )
            log.success("Training pipeline completed")

        if skip_estimation_measurement:
            log.step(
                f"Estimation measurement and preprocessing SKIPPED (using existing test segments CSV: {test_segments_csv})"
            )
        else:
            measure_and_preprocess(
                cfg,
                options.estimate_file,
                test_segments_csv,
                estimate_labels_json,
                options.estimate_defines,
                options.measurement,
            )

        print()
        log.info("==> Hardware no longer required - remaining steps can run offline")
        print()

        # The measured program repeats its workload NUM_REPEAT times; the estimate
        # is for a single repetition.
        log.step("Compiling estimation file for estimation")
        log.info("Compiling for estimation (with NUM_REPEAT=1)")
        compile_and_disasm(
            cfg,
            options.estimate_file,
            defines_util.override(options.estimate_defines, "NUM_REPEAT", "1"),
        )

        log.step("Estimating energy consumption")
        run_julia(
            PROJECT_ROOT,
            "estimate",
            [
                "--asm",
                cfg.asm_dir / f"{estimate_base}.asm",
                "--params",
                params_file,
                "--output",
                estimated_stats_json,
                "--data-dump",
                cfg.asm_dir / f"{estimate_base}.data",
                *(
                    ["--intercept-special-calls"]
                    if options.intercept_special_calls
                    else []
                ),
                *(
                    ["--max-steps", options.max_steps]
                    if options.max_steps is not None
                    else []
                ),
            ],
        )
        log.success(f"Estimation complete: {estimated_stats_json}")

        log.step("Generating comparison report")
        num_repeat = defines_util.extract(options.estimate_defines, "NUM_REPEAT")
        if not num_repeat:
            raise PipelineError(
                "NUM_REPEAT not found in the estimation defines. "
                "Please add NUM_REPEAT=<value> to --estimate-defines"
            )
        log.info(f"Using NUM_REPEAT={num_repeat} from estimation defines")

        run_module(
            "reports.generate_comparison_report",
            [
                "--estimated-stats",
                estimated_stats_json,
                "--measured-data",
                test_segments_csv,
                "--report-dir",
                report_dir,
                "--num-repeat",
                num_repeat,
            ],
        )
        log.success(f"Comparison report generated: {report_dir}")

        log.step("PIPELINE COMPLETE")
        log.success("All steps completed successfully!")
        print()
        log.info("Output files:")
        print(f"  - Comparison Report: {report_dir}/")
        print("    - comparison.md (detailed markdown report with all events)")
        print("    - event_N_estimated.png (per-event estimated distributions)")
        print("    - event_N_measured.png (per-event measured distributions)")
        print("    - event_N_comparison.png (per-event comparisons)")
        if not temp_test_segments:
            print(f"  - Test Segments CSV: {test_segments_csv}")
        if not temp_params:
            print(f"  - Parameters: {params_file}")
    finally:
        estimated_stats_json.unlink(missing_ok=True)
        estimate_labels_json.unlink(missing_ok=True)
        if not options.keep_intermediates:
            if temp_params and params_file.is_file():
                log.info(f"Cleaning up temporary params file: {params_file}")
                params_file.unlink()
            if temp_test_segments and test_segments_csv.is_file():
                log.info(
                    f"Cleaning up temporary test segments CSV: {test_segments_csv}"
                )
                test_segments_csv.unlink()
