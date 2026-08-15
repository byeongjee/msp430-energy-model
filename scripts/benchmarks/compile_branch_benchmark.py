"""Reassemblable .S generation for the hardcoded branch benchmarks.

The branch chains keep their full control flow inside inline asm so the generated
assembly stays stable under optimization.
"""

from pathlib import Path

from benchmarks.common import normalize_generated_asm_isa
from pipeline import log
from pipeline.build import compile_source
from pipeline.config import Config
from pipeline.errors import PipelineError

SUPPORTED_BENCHMARKS = ("br_immediate_benchmark", "br_indexed_benchmark")


def generate_assembly(cfg: Config, source: Path, defines: str = "") -> Path:
    """Compile a branch benchmark to assembly and return the generated .S file."""
    base = source.stem
    if base not in SUPPORTED_BENCHMARKS:
        raise PipelineError(
            f"Unknown hardcoded benchmark: {base}. "
            f"Only {' and '.join(SUPPORTED_BENCHMARKS)} are currently supported"
        )

    asm_source = cfg.asm_dir / f"{base}.S"
    log.info(f"Generating assembly source for: {source}")
    compile_source(cfg, source, defines, extra_flags=["-S"], output=asm_source)
    normalize_generated_asm_isa(asm_source)

    log.success(f"Assembly generation completed: {asm_source}")
    return asm_source
