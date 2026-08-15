"""Command line interface for the MSP430 energy modeling pipeline."""

import argparse
import sys
from pathlib import Path

from pipeline import (
    analyze_distribution,
    commands,
    config,
    fixtures,
    log,
    testing,
    train,
)
from pipeline import train_and_estimate as train_and_estimate_pipeline
from pipeline.config import MAX_CURRENT_DEFAULT, VOLTAGE_DEFAULT, GRANULARITY_TO_MODEL
from pipeline.errors import PipelineError
from pipeline.measure import MeasurementSettings

GRANULARITIES = list(GRANULARITY_TO_MODEL)


def _add_source(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--file", type=Path, required=True, help="C or assembly source file"
    )
    parser.add_argument(
        "--defines",
        default="",
        help='Space-separated compiler macros (e.g. "FOO=1 BAR")',
    )


def _add_measurement(parser: argparse.ArgumentParser) -> None:
    parser.add_argument("--voltage", type=float, default=VOLTAGE_DEFAULT, help="V")
    parser.add_argument(
        "--max-current", type=float, default=MAX_CURRENT_DEFAULT, help="A"
    )
    parser.add_argument(
        "--skip-flash",
        action="store_true",
        help="Measure the program already on the target",
    )


def _add_model(parser: argparse.ArgumentParser, default_inference: str) -> None:
    parser.add_argument("--max-steps", type=int, help="Maximum execution steps")
    parser.add_argument("--n-samples", type=int, help="Number of samples for inference")
    parser.add_argument(
        "--model", default="mean_per_addressing_mode", help="Energy model"
    )
    parser.add_argument(
        "--inference", default=default_inference, help="Inference algorithm"
    )
    parser.add_argument(
        "--intercept-special-calls",
        action="store_true",
        help="Model __mspabi_* helper calls as single composite instructions",
    )


def _measurement_settings(args: argparse.Namespace) -> MeasurementSettings:
    return MeasurementSettings(
        voltage=args.voltage, max_current=args.max_current, skip_flash=args.skip_flash
    )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="pem", description="MSP430 probabilistic energy modeling pipeline"
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    compile_parser = subparsers.add_parser(
        "compile", help="Compile a program to an ELF binary"
    )
    _add_source(compile_parser)

    disasm_parser = subparsers.add_parser(
        "disasm", help="Compile and disassemble a program"
    )
    _add_source(disasm_parser)

    interpret_parser = subparsers.add_parser(
        "interpret", help="Interpret a program and list the parameters it requires"
    )
    _add_source(interpret_parser)
    interpret_parser.add_argument("--max-steps", type=int)
    interpret_parser.add_argument("--granularity", choices=GRANULARITIES)
    interpret_parser.add_argument("--model", default="", help="Overrides --granularity")
    interpret_parser.add_argument("--intercept-special-calls", action="store_true")

    estimate_parser = subparsers.add_parser(
        "estimate", help="Estimate the energy of a program"
    )
    _add_source(estimate_parser)
    estimate_parser.add_argument(
        "--params", type=Path, required=True, help="Parameter JSON file"
    )
    estimate_parser.add_argument("--plot", type=Path, help="Write a plot to this file")
    estimate_parser.add_argument("--max-steps", type=int)
    estimate_parser.add_argument("--intercept-special-calls", action="store_true")

    flash_parser = subparsers.add_parser(
        "flash", help="Flash a program to the microcontroller"
    )
    _add_source(flash_parser)

    train_parser = subparsers.add_parser(
        "train", help="Training pipeline: measure → preprocess → train"
    )
    train_parser.add_argument(
        "--files",
        required=True,
        help="Training file pattern (globs and braces supported)",
    )
    train_parser.add_argument(
        "--training-segments-csv",
        default="",
        help="Preprocessed segments CSV files, matched to the training files by basename",
    )
    train_parser.add_argument("--params", type=Path, help="Output parameter JSON file")
    train_parser.add_argument("--tag", default="", help="Tag for naming output files")
    train_parser.add_argument(
        "--defines", default="", help="Space-separated compiler macros"
    )
    train_parser.add_argument("--keep-intermediates", action="store_true")
    _add_model(train_parser, default_inference="map")
    _add_measurement(train_parser)

    train_and_estimate_parser = subparsers.add_parser(
        "train-and-estimate",
        help="Full pipeline: train → measure → estimate → compare",
    )
    train_and_estimate_parser.add_argument("--train-files", required=True)
    train_and_estimate_parser.add_argument("--estimate-file", type=Path, required=True)
    train_and_estimate_parser.add_argument("--training-segments-csv", default="")
    train_and_estimate_parser.add_argument("--test-segments-csv", default="")
    train_and_estimate_parser.add_argument("--params", type=Path)
    train_and_estimate_parser.add_argument("--tag", default="")
    train_and_estimate_parser.add_argument("--train-defines", default="")
    train_and_estimate_parser.add_argument(
        "--estimate-defines", default="", help="Must include NUM_REPEAT=<value>"
    )
    train_and_estimate_parser.add_argument("--report-dir", type=Path)
    train_and_estimate_parser.add_argument("--keep-intermediates", action="store_true")
    _add_model(train_and_estimate_parser, default_inference="importance-sampling")
    _add_measurement(train_and_estimate_parser)

    analyze_parser = subparsers.add_parser(
        "analyze-distribution",
        help="Flash, measure and analyze the energy distribution per event",
    )
    analyze_parser.add_argument("--files", required=True)
    analyze_parser.add_argument(
        "--segments-csv", default="", help="Pre-measured segments CSV files"
    )
    analyze_parser.add_argument("--tag", default="")
    analyze_parser.add_argument(
        "--defines", default="", help="Must include NUM_REPEAT=<value>"
    )
    analyze_parser.add_argument("--report-dir", type=Path)
    _add_measurement(analyze_parser)

    benchmarks_parser = subparsers.add_parser(
        "gen-benchmarks", help="Generate the benchmarks a program needs for estimation"
    )
    _add_source(benchmarks_parser)
    benchmarks_parser.add_argument(
        "--granularity", choices=GRANULARITIES, default="addressing_mode_constant"
    )
    benchmarks_parser.add_argument("--output-dir", type=Path, default=Path("tmp"))
    benchmarks_parser.add_argument(
        "--batch", type=int, help="Benchmarks per generated file"
    )
    benchmarks_parser.add_argument("--max-steps", type=int)

    keys_parser = subparsers.add_parser(
        "gen-benchmarks-from-keys", help="Generate benchmarks listed in a keys file"
    )
    keys_parser.add_argument(
        "--keys", type=Path, required=True, help="File listing key names"
    )
    keys_parser.add_argument(
        "--granularity", choices=GRANULARITIES, default="addressing_mode"
    )
    keys_parser.add_argument("--output-dir", type=Path, required=True)
    keys_parser.add_argument("--batch", type=int)
    keys_parser.add_argument("--defines", default="")

    branch_parser = subparsers.add_parser(
        "compile-branch-benchmark",
        help="Generate the reassemblable .S file of a hardcoded branch benchmark",
    )
    _add_source(branch_parser)

    fixture_parser = subparsers.add_parser(
        "create-fixture",
        help="Create an interpreter test fixture with the GDB simulator",
    )
    fixture_parser.add_argument("--file", type=Path, required=True)
    fixture_parser.add_argument("--name", required=True, help="Fixture name")

    test_parser = subparsers.add_parser(
        "test", help="Run the Julia and Python test suites"
    )
    test_parser.add_argument("--pattern", default="", help="Only run matching tests")

    subparsers.add_parser("info", help="Show the build and toolchain configuration")
    subparsers.add_parser("clean", help="Remove the build artifacts")

    return parser


def dispatch(args: argparse.Namespace) -> int:
    if args.command == "test":
        return testing.run(args.pattern)

    cfg = config.load()

    if args.command == "compile":
        commands.compile_only(cfg, args.file, args.defines)
    elif args.command == "disasm":
        commands.disasm(cfg, args.file, args.defines)
    elif args.command == "interpret":
        commands.interpret(
            cfg,
            args.file,
            args.defines,
            max_steps=args.max_steps,
            granularity=args.granularity or "",
            model=args.model,
            intercept_special_calls=args.intercept_special_calls,
        )
    elif args.command == "estimate":
        commands.estimate(
            cfg,
            args.file,
            args.params,
            args.defines,
            plot=args.plot,
            max_steps=args.max_steps,
            intercept_special_calls=args.intercept_special_calls,
        )
    elif args.command == "flash":
        commands.flash(cfg, args.file, args.defines)
    elif args.command == "train":
        train.run(
            cfg,
            train.TrainOptions(
                files=args.files,
                training_segments_csv=args.training_segments_csv,
                params=args.params,
                tag=args.tag,
                max_steps=args.max_steps,
                n_samples=args.n_samples,
                model=args.model,
                inference=args.inference,
                defines=args.defines,
                keep_intermediates=args.keep_intermediates,
                intercept_special_calls=args.intercept_special_calls,
                measurement=_measurement_settings(args),
            ),
        )
    elif args.command == "train-and-estimate":
        train_and_estimate_pipeline.run(
            cfg,
            train_and_estimate_pipeline.TrainAndEstimateOptions(
                train_files=args.train_files,
                estimate_file=args.estimate_file,
                training_segments_csv=args.training_segments_csv,
                test_segments_csv=args.test_segments_csv,
                params=args.params,
                tag=args.tag,
                max_steps=args.max_steps,
                n_samples=args.n_samples,
                model=args.model,
                inference=args.inference,
                train_defines=args.train_defines,
                estimate_defines=args.estimate_defines,
                report_dir=args.report_dir,
                keep_intermediates=args.keep_intermediates,
                intercept_special_calls=args.intercept_special_calls,
                measurement=_measurement_settings(args),
            ),
        )
    elif args.command == "analyze-distribution":
        analyze_distribution.run(
            cfg,
            analyze_distribution.AnalyzeOptions(
                files=args.files,
                segments_csv=args.segments_csv,
                tag=args.tag,
                defines=args.defines,
                report_dir=args.report_dir,
                measurement=_measurement_settings(args),
            ),
        )
    elif args.command == "gen-benchmarks":
        from benchmarks import generate_required

        generate_required.run(
            cfg,
            args.file,
            args.granularity,
            args.output_dir,
            batch=args.batch,
            max_steps=args.max_steps,
            defines=args.defines,
        )
    elif args.command == "gen-benchmarks-from-keys":
        from benchmarks import generate_from_keys

        generate_from_keys.run(
            cfg,
            args.keys,
            args.granularity,
            args.output_dir,
            batch=args.batch,
            defines=args.defines,
        )
    elif args.command == "compile-branch-benchmark":
        from benchmarks.compile_branch_benchmark import generate_assembly

        generate_assembly(cfg, args.file, args.defines)
    elif args.command == "create-fixture":
        fixtures.create(cfg, args.file, args.name)
    elif args.command == "info":
        commands.info(cfg)
    elif args.command == "clean":
        commands.clean(cfg)

    return 0


def main() -> None:
    args = build_parser().parse_args()
    try:
        sys.exit(dispatch(args))
    except PipelineError as error:
        log.error(str(error))
        sys.exit(1)


if __name__ == "__main__":
    main()
