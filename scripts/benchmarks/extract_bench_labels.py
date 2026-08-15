#!/usr/bin/env python3
"""
Extract function names from BENCH() macros in C source files.
Outputs event labels that can be used for naming in reports and CSV files.
"""

import argparse
import json
from pathlib import Path
import re
import sys


REPO_ROOT = Path(__file__).resolve().parents[2]


def extract_bench_labels_from_c_content(content):
    """Extract BENCH() labels from C source content."""
    main_pattern = r'int\s+main\s*\([^)]*\)\s*\{(.*)\}'
    main_match = re.search(main_pattern, content, re.DOTALL)
    if not main_match:
        return []

    main_body = main_match.group(1)
    bench_pattern = r'BENCH\s*\(\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*\([^)]*\)\s*\)'
    return re.findall(bench_pattern, main_body)


def iter_assembly_source_candidates(content):
    """Yield candidate C source paths embedded in generated assembly."""
    seen = set()

    for candidate in re.findall(r'^\s*\.file\s+"([^"]+\.c)"', content, re.MULTILINE):
        if candidate not in seen:
            seen.add(candidate)
            yield candidate

    for candidate in re.findall(r'"([^"]+\.c)"', content):
        if candidate not in seen:
            seen.add(candidate)
            yield candidate


def resolve_assembly_source(asm_path, candidate):
    """Resolve a C source reference found inside generated assembly."""
    candidate_path = Path(candidate)
    candidate_name = candidate_path.name

    direct_candidates = [
        candidate_path,
        asm_path.parent / candidate_path,
        asm_path.parent / candidate_name,
        REPO_ROOT / candidate_path,
        REPO_ROOT / candidate_name,
        REPO_ROOT / "scripts" / "benchmarks" / "hardcoded" / candidate_name,
    ]

    for path in direct_candidates:
        if path.exists():
            return path.resolve()

    matches = sorted(REPO_ROOT.rglob(candidate_name))
    if len(matches) == 1:
        return matches[0].resolve()

    hardcoded_matches = [
        path.resolve()
        for path in matches
        if path.parent == REPO_ROOT / "scripts" / "benchmarks" / "hardcoded"
    ]
    if len(hardcoded_matches) == 1:
        return hardcoded_matches[0]

    return None


def extract_bench_labels(file_path, visited=None):
    """
    Extract function names from BENCH() calls in C source or generated assembly.

    Args:
        file_path: Path to a C or S source file

    Returns:
        List of function names extracted from BENCH() calls
    """
    path = Path(file_path).resolve()
    if visited is None:
        visited = set()
    if path in visited:
        return []
    visited.add(path)

    with path.open("r") as f:
        content = f.read()

    labels = extract_bench_labels_from_c_content(content)
    if labels:
        return labels

    if path.suffix == ".S":
        for candidate in iter_assembly_source_candidates(content):
            source_path = resolve_assembly_source(path, candidate)
            if source_path is None:
                continue

            labels = extract_bench_labels(source_path, visited=visited)
            if labels:
                return labels

    return []


def main():
    parser = argparse.ArgumentParser(
        description='Extract function names from BENCH() macros in C source files'
    )
    parser.add_argument('--input', required=True,
                       help='Path to C source file')
    parser.add_argument('--output', required=True,
                       help='Path to output JSON file')
    parser.add_argument('--format', choices=['json', 'text'], default='json',
                       help='Output format (default: json)')

    args = parser.parse_args()

    # Extract labels
    labels = extract_bench_labels(args.input)

    if not labels:
        print(f"Warning: No BENCH() macros found in {args.input}", file=sys.stderr)
    else:
        print(f"Extracted {len(labels)} event labels from {args.input}")
        for i, label in enumerate(labels, 1):
            print(f"  Event {i}: {label}")

    # Save to output file
    if args.format == 'json':
        with open(args.output, 'w') as f:
            json.dump(labels, f, indent=2)
    else:  # text format
        with open(args.output, 'w') as f:
            for label in labels:
                f.write(f"{label}\n")

    print(f"Saved to {args.output}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
