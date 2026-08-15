"""Generation of the benchmarks needed to estimate the energy of one program."""

import re
from pathlib import Path

from benchmarks.selection import generate, select
from pipeline import log
from pipeline.build import compile_and_disasm
from pipeline.config import PROJECT_ROOT, Config, granularity_to_model, timestamp
from pipeline.errors import PipelineError
from pipeline.process import capture, julia_command, julia_env

_ALL_EVENTS = re.compile(r"All events param_(keys|pairs): (.*)")


def toolchain_env(cfg: Config) -> dict:
    """Compiler settings for benchmarks.gen_benchmarks, which compiles the
    hardcoded benchmarks itself."""
    return {
        **julia_env(),
        "CC": str(cfg.cc),
        "CFLAGS": " ".join(cfg.cflags),
        "INCLUDES": " ".join(cfg.includes),
    }


def parse_required_keys(interpret_output: str) -> list[str]:
    """Read the parameter keys the interpreter reported for a program."""
    matches = _ALL_EVENTS.findall(interpret_output)
    if not matches:
        raise PipelineError("No parameter keys found in the interpreter output")

    kind, keys = matches[-1]
    # Pair keys are printed as "key1 -> key2"; benchmarks name them "key1__key2".
    if kind == "pairs":
        keys = keys.replace(" -> ", "__")
    return keys.split()


def run(
    cfg: Config,
    source: Path,
    granularity: str,
    output_dir: Path,
    batch: int | None = None,
    max_steps: int | None = None,
    defines: str = "",
) -> None:
    model = granularity_to_model(granularity)
    cfg.temp_dir.mkdir(parents=True, exist_ok=True)
    log_file = cfg.temp_dir / f"interpret_keys_{timestamp()}.log"

    log.info(
        f"Running interpret to extract required keys (granularity={granularity}, model={model})..."
    )
    asm_file, data_file = compile_and_disasm(cfg, source, defines)
    output = capture(
        julia_command(
            PROJECT_ROOT,
            "interpret",
            [
                "--asm",
                asm_file,
                "--data-dump",
                data_file,
                "--model",
                model,
                *(["--max-steps", max_steps] if max_steps is not None else []),
            ],
        ),
        env=julia_env(),
        stderr_to_stdout=True,
    )
    log_file.write_text(output)

    keys = parse_required_keys(output)
    log.info(f"Filtering benchmark list for {len(keys)} key(s)")

    payload, missing = select(granularity, keys)
    if missing:
        log.warn(
            f"Missing benchmarks in benchmarks.list_benchmarks for: {' '.join(missing)}"
        )

    log.info(f"Generating benchmarks to directory {output_dir}...")
    generate(
        granularity,
        payload,
        cfg.temp_dir / f"required_keys_{timestamp()}.json",
        output_dir,
        batch=batch,
        defines=defines,
        env=toolchain_env(cfg),
    )
    log.success(f"Benchmarks written to {output_dir} (log: {log_file})")
