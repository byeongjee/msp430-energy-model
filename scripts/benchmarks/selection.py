"""Selection of the benchmarks that cover a set of parameter keys."""

import json
from pathlib import Path

from benchmarks.common import normalize_granularity
from benchmarks.list_benchmarks import build_listing
from pipeline.process import run_module


def payload_name(granularity: str) -> str:
    return (
        "pairs"
        if normalize_granularity(granularity).endswith("pair")
        else "instructions"
    )


def select(granularity: str, wanted: list[str]) -> tuple[dict, list[str]]:
    """Filter the benchmark listing down to the wanted keys.

    Returns the JSON payload for benchmarks.gen_benchmarks, plus the wanted keys
    that no benchmark covers.
    """
    listing = build_listing(granularity)
    name = payload_name(granularity)

    available = listing.get(name, [])
    hardcoded = listing.get("hardcoded_benchmarks", [])

    covered = {entry["name"] for entry in available} | {
        entry["name"] for entry in hardcoded
    }
    payload = {
        name: [entry for entry in available if entry["name"] in wanted],
        "hardcoded_benchmarks": [
            entry for entry in hardcoded if entry["name"] in wanted
        ],
        "model_benchmarks": listing.get("model_benchmarks", []),
    }
    return payload, [key for key in wanted if key not in covered]


def generate(
    granularity: str,
    payload: dict,
    payload_json: Path,
    output_dir: Path,
    batch: int | None = None,
    defines: str = "",
    env: dict | None = None,
) -> None:
    """Write the payload to a JSON file and generate the benchmarks from it."""
    output_dir.mkdir(parents=True, exist_ok=True)
    payload_json.parent.mkdir(parents=True, exist_ok=True)
    payload_json.write_text(json.dumps(payload, indent=2))

    run_module(
        "benchmarks.gen_benchmarks",
        [
            "--granularity",
            granularity,
            "--input",
            payload_json,
            "--output-dir",
            output_dir,
            *(["--batch", batch] if batch else []),
            *(["--defines", defines] if defines else []),
        ],
        env=env,
    )
