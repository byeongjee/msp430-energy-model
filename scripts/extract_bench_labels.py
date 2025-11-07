#!/usr/bin/env python3
"""
Extract function names from BENCH() macros in C source files.
Outputs event labels that can be used for naming in reports and CSV files.
"""

import argparse
import json
import re
import sys


def extract_bench_labels(c_file_path):
    """
    Extract function names from BENCH() macro calls in main() function.

    Args:
        c_file_path: Path to C source file

    Returns:
        List of function names extracted from BENCH() calls
    """
    with open(c_file_path, 'r') as f:
        content = f.read()

    # Find the main function
    # Pattern to match: int main(...) { ... }
    main_pattern = r'int\s+main\s*\([^)]*\)\s*\{(.*)\}'
    main_match = re.search(main_pattern, content, re.DOTALL)

    if not main_match:
        print(f"Warning: Could not find main() function in {c_file_path}", file=sys.stderr)
        return []

    main_body = main_match.group(1)

    # Find all BENCH() macro calls
    # Pattern matches: BENCH(function_name(...))
    # We want to extract the function name, handling both:
    # - BENCH(func())
    # - BENCH(func(args))
    bench_pattern = r'BENCH\s*\(\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*\([^)]*\)\s*\)'

    labels = re.findall(bench_pattern, main_body)

    return labels


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
