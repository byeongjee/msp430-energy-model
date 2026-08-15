"""Generation of benchmarks from a file listing parameter keys."""

import re
from pathlib import Path

from benchmarks.generate_required import toolchain_env
from benchmarks.selection import generate, select
from pipeline import log
from pipeline.config import Config, timestamp
from pipeline.errors import PipelineError


def read_keys(keys_file: Path) -> list[str]:
    """Read keys separated by commas, newlines, tabs or spaces."""
    if not keys_file.is_file():
        raise PipelineError(f"Keys file not found: {keys_file}")
    return re.split(r"[,\s]+", keys_file.read_text().strip())


def run(
    cfg: Config,
    keys_file: Path,
    granularity: str,
    output_dir: Path,
    batch: int | None = None,
    defines: str = "",
) -> None:
    keys = [key for key in read_keys(keys_file) if key]

    log.step("Generating benchmarks from keys")
    log.info(f"Keys file:    {keys_file}")
    log.info(f"Granularity:  {granularity}")
    log.info(f"Output dir:   {output_dir}")
    log.info(f"Key count:    {len(keys)}")
    if defines:
        log.info(f"Defines:      {defines}")

    payload, missing = select(granularity, keys)
    if missing:
        log.warn(
            f"Missing benchmarks in benchmarks.list_benchmarks for: {' '.join(missing)}"
        )

    cfg.temp_dir.mkdir(parents=True, exist_ok=True)
    generate(
        granularity,
        payload,
        cfg.temp_dir / f"selected_keys_{timestamp()}.json",
        output_dir,
        batch=batch,
        defines=defines,
        env=toolchain_env(cfg),
    )
    log.success(f"Benchmarks written to {output_dir}")
