"""File pattern expansion and basename matching."""

import glob
from fnmatch import fnmatch
from pathlib import Path

from pipeline import log
from pipeline.errors import PipelineError


def source_basename(file: Path | str) -> str:
    """Basename without the .c or .S extension."""
    name = Path(file).name
    for suffix in (".c", ".S"):
        if name.endswith(suffix):
            return name[: -len(suffix)]
    return name


def _expand_braces(pattern: str) -> list[str]:
    start = pattern.find("{")
    end = pattern.find("}", start + 1)
    if start == -1 or end == -1:
        return [pattern]

    before, content, after = (
        pattern[:start],
        pattern[start + 1 : end],
        pattern[end + 1 :],
    )
    return [
        expanded
        for item in content.split(",")
        for expanded in _expand_braces(f"{before}{item}{after}")
    ]


def expand_file_input(pattern: str) -> list[Path]:
    """Expand a file pattern, supporting globs, recursive globs and brace expansion.

    Supported forms: "examples/simple.c", "examples/*.c", "examples/**/*.c",
    "examples/{a,b}.c" and combinations of them.
    """
    files: set[str] = set()

    for expanded in _expand_braces(pattern):
        if "**" in expanded:
            prefix, _, suffix = expanded.partition("**")
            suffix = suffix.lstrip("/")
            root = Path(prefix) if prefix else Path(".")
            for path in root.rglob("*"):
                if path.is_file() and (not suffix or fnmatch(str(path), f"*{suffix}")):
                    files.add(str(path))
        elif "*" in expanded or "?" in expanded:
            files.update(
                match for match in glob.glob(expanded) if Path(match).is_file()
            )
        elif Path(expanded).is_file():
            files.add(expanded)

    return [Path(file) for file in sorted(files)]


def match_files_by_basename(
    sources: list[Path], pattern: str, kind: str = "CSV"
) -> list[Path | None]:
    """Match each source file to one file from `pattern`, by basename.

    A pattern containing "{filename}" is substituted with each source basename;
    any other pattern (glob or semicolon-separated list) forms a pool whose
    basenames are searched for the source basename as a substring.

    Returns one entry per source, None where nothing matched.
    """
    matched: list[Path | None] = []
    unmatched: list[Path] = []

    if "{filename}" in pattern:
        for source in sources:
            base = source_basename(source)
            candidates = sorted(glob.glob(pattern.replace("{filename}", base)))
            if candidates:
                matched.append(Path(candidates[0]))
                if len(candidates) > 1:
                    log.warn(f"Multiple matches for {base}, using: {candidates[0]}")
            else:
                matched.append(None)
                unmatched.append(source)
    else:
        if ";" in pattern:
            pool = [Path(entry) for entry in pattern.split(";") if entry]
        else:
            pool = expand_file_input(pattern)

        for source in sources:
            base = source_basename(source)
            match = next(
                (candidate for candidate in pool if base in candidate.name), None
            )
            matched.append(match)
            if match is None:
                unmatched.append(source)

    if unmatched:
        log.warn(
            f"No matching {kind} files found for {len(unmatched)} source file(s) (will be measured):"
        )
        for source in unmatched:
            log.warn(f"  - {source_basename(source)}")

    return matched


def match_single_file(pattern: str, kind: str = "CSV") -> Path:
    """Expand a pattern that must match exactly one file."""
    matches = expand_file_input(pattern)
    if not matches:
        raise PipelineError(f"No {kind} files found for pattern: {pattern}")
    if len(matches) > 1:
        listed = "\n".join(f"  - {match}" for match in matches)
        raise PipelineError(
            f"Expected exactly 1 {kind} file, but found {len(matches)} matches for "
            f"pattern: {pattern}\n{listed}"
        )
    return matches[0]


def expand_required(pattern: str, description: str) -> list[Path]:
    """Expand a pattern that must match at least one file."""
    files = expand_file_input(pattern)
    if not files:
        raise PipelineError(f"No {description} found matching pattern: {pattern}")
    return files
