#!/usr/bin/env python3
import json
import argparse
from pathlib import Path

import numpy as np
import matplotlib.pyplot as plt

# -----------------------------------------------------------------------------
# This script draws a heatmap of instruction costs across multiple boards.
# Rows are instruction+addressing-mode keys, columns are boards (JSON files).
# By normalizing each board (e.g., by its mean or a chosen anchor instruction),
# we can visually check whether the relative cost pattern is preserved.
# -----------------------------------------------------------------------------


def load_parameters(path: Path):
    with open(path, "r") as f:
        data = json.load(f)
    if "parameters" not in data or not isinstance(data["parameters"], dict):
        raise ValueError(f"{path} does not contain a 'parameters' dict at top level")
    return data["parameters"]


def main():
    parser = argparse.ArgumentParser(
        description="Heatmap of instruction costs across multiple boards"
    )
    parser.add_argument(
        "json_files",
        type=Path,
        nargs="+",
        help="JSON files, each containing a 'parameters' dict",
    )
    parser.add_argument(
        "--title",
        type=str,
        default=None,
        help="Optional plot title",
    )
    parser.add_argument(
        "--norm",
        type=str,
        choices=["none", "mean", "anchor"],
        default="mean",
        help=(
            "Normalization mode: none, mean (divide by per-board mean of common keys), "
            "or anchor (divide by a specific key per board). Default: mean."
        ),
    )
    parser.add_argument(
        "--anchor-key",
        type=str,
        default=None,
        help="Instruction key to use as anchor when --norm=anchor "
        "(e.g., 'add_register_register').",
    )
    parser.add_argument(
        "--fmt",
        type=str,
        default=".2f",
        help="Format string for cell text (default: .2f)",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="Optional output file path to save the plot (e.g., heatmap.png)",
    )

    args = parser.parse_args()

    if len(args.json_files) < 2:
        raise SystemExit("Provide at least two JSON files for heatmap comparison.")

    # Load all parameters
    all_params = [load_parameters(p) for p in args.json_files]
    all_key_sets = [set(p.keys()) for p in all_params]

    # Intersection of all keys for comparability
    common_keys = sorted(set.intersection(*all_key_sets))
    if not common_keys:
        raise SystemExit("No common parameter keys among the given JSON files.")

    # Report dropped keys per file (sorted for consistency)
    for path, key_set in zip(args.json_files, all_key_sets):
        dropped = sorted(key_set - set(common_keys))
        if dropped:
            print(f"{path.name}: keys not in intersection (ignored): {len(dropped)}")
            # Uncomment to see actual names:
            # for k in dropped:
            #     print("  ", k)

    # Build a matrix: rows = instructions, cols = boards
    raw_matrix = np.zeros((len(common_keys), len(args.json_files)))
    for j, params in enumerate(all_params):
        raw_matrix[:, j] = np.array([params[k] for k in common_keys])

    # Normalization
    matrix = raw_matrix.copy()

    if args.norm == "mean":
        means = matrix.mean(axis=0)
        print("Per-board means (used for normalization):")
        for path, m in zip(args.json_files, means):
            print(f"  {path.name}: mean = {m:.6f}")
        matrix = matrix / means

    elif args.norm == "anchor":
        if args.anchor_key is None:
            raise SystemExit("--anchor-key must be provided when --norm=anchor")
        if args.anchor_key not in common_keys:
            raise SystemExit(
                f"Anchor key '{args.anchor_key}' is not in the intersection "
                "of keys across all boards."
            )
        anchor_idx = common_keys.index(args.anchor_key)
        anchors = matrix[anchor_idx, :]
        print(f"Anchor key: {args.anchor_key}")
        print("Per-board anchor values (used for normalization):")
        for path, a in zip(args.json_files, anchors):
            print(f"  {path.name}: anchor = {a:.6f}")
        matrix = matrix / anchors

    else:
        print("Normalization: none (using raw parameter values).")

    n_instr, n_boards = matrix.shape

    # Figure size: scale with number of boards and instructions for readability
    fig_width = max(8, 1.5 * n_boards)
    fig_height = max(10, 0.25 * n_instr)

    plt.figure(figsize=(fig_width, fig_height))

    # Draw heatmap
    im = plt.imshow(matrix, aspect="auto")
    cbar_label = "Normalized cost" if args.norm != "none" else "Cost"
    plt.colorbar(im, label=cbar_label)

    # Axis ticks/labels
    plt.xticks(
        ticks=np.arange(n_boards),
        labels=[p.name for p in args.json_files],
        rotation=45,
        ha="right",
    )
    plt.yticks(
        ticks=np.arange(n_instr),
        labels=common_keys,
        fontsize=8,
    )

    # Add numeric value in each cell
    # Choose text color based on background intensity for readability
    vmin, vmax = float(np.nanmin(matrix)), float(np.nanmax(matrix))
    vcenter = (vmin + vmax) / 2.0 if np.isfinite(vmin) and np.isfinite(vmax) else 0.0

    for i in range(n_instr):
        for j in range(n_boards):
            val = matrix[i, j]
            # Protect against NaN just in case
            if np.isnan(val):
                text_str = "nan"
            else:
                text_str = format(val, args.fmt)
            color = "white" if val > vcenter else "black"
            plt.text(
                j,
                i,
                text_str,
                ha="center",
                va="center",
                fontsize=7,
                color=color,
            )

    # Title
    if args.title:
        plt.title(args.title)
    else:
        if args.norm == "mean":
            plt.title("Instruction cost heatmap (normalized by per-board mean)")
        elif args.norm == "anchor":
            plt.title(
                f"Instruction cost heatmap (normalized by anchor: {args.anchor_key})"
            )
        else:
            plt.title("Instruction cost heatmap (raw values)")

    plt.tight_layout()

    if args.output:
        plt.savefig(args.output, dpi=300, bbox_inches="tight")
        print(f"Plot saved to {args.output}")
    else:
        plt.show()


if __name__ == "__main__":
    main()
