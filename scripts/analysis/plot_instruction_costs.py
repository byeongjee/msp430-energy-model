#!/usr/bin/env python3
"""
Plot cost distribution of instructions from energy parameters JSON file.

This script reads a JSON file containing instruction energy parameters (alpha, beta)
and visualizes their distributions in a grid layout.
"""

import argparse
import json
import math
import sys

import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import gamma


def load_energy_params(filename):
    """Load energy parameters from JSON file."""
    with open(filename, "r") as f:
        return json.load(f)


def calculate_grid_layout(num_items, rows=None, cols=None):
    """
    Calculate optimal grid layout for given number of items.

    Args:
        num_items: Number of subplots needed
        rows: Number of rows (optional)
        cols: Number of columns (optional)

    Returns:
        Tuple of (rows, cols)

    Raises:
        ValueError: If specified grid is too small for the number of items
    """
    if rows is not None and cols is not None:
        # Validate that grid is large enough
        if rows * cols < num_items:
            raise ValueError(
                f"Grid size {rows}x{cols} = {rows * cols} cells is too small "
                f"for {num_items} instructions. Need at least {num_items} cells."
            )
        return rows, cols
    elif rows is not None:
        cols = math.ceil(num_items / rows)
        return rows, cols
    elif cols is not None:
        rows = math.ceil(num_items / cols)
        return rows, cols
    else:
        # Auto-calculate: prefer wider layouts
        cols = math.ceil(math.sqrt(num_items * 1.5))
        rows = math.ceil(num_items / cols)
        return rows, cols


def plot_distributions(energy_params, rows, cols, output_path=None):
    """
    Plot cost distributions for all instructions.

    Args:
        energy_params: Dictionary of instruction parameters
        rows: Number of rows in grid (None for single plot)
        cols: Number of columns in grid (None for single plot)
        output_path: Path to save figure (optional)
    """
    instructions = sorted(energy_params.keys())
    num_instructions = len(instructions)

    # Generate x values for plotting
    x = np.linspace(0, 20, 500)

    # Single plot mode: all distributions in one frame
    if rows is None and cols is None:
        fig, ax = plt.subplots(1, 1, figsize=(10, 6))
        fig.suptitle("Instruction Cost Distributions", fontsize=16, fontweight="bold")

        # Use a colormap for different instructions
        colors = plt.cm.tab20(np.linspace(0, 1, num_instructions))

        for idx, instruction in enumerate(instructions):
            params = energy_params[instruction]
            alpha = params["alpha"]
            beta = params["beta"]

            # Plot gamma distribution
            y = gamma.pdf(x, a=alpha, scale=beta)
            ax.plot(x, y, linewidth=2, label=instruction, color=colors[idx])

        ax.set_xlabel("Cost (nJ)", fontsize=12)
        ax.set_ylabel("Density", fontsize=12)
        ax.grid(True, alpha=0.3, linestyle="--")
        ax.legend(loc="upper right", fontsize=8, ncol=2)
        plt.tight_layout()

    # Grid mode: each instruction in separate subplot
    else:
        fig, axes = plt.subplots(rows, cols, figsize=(4 * cols, 3 * rows))
        fig.suptitle("Instruction Cost Distributions", fontsize=16, fontweight="bold")

        # Flatten axes array for easier indexing
        if rows == 1 and cols == 1:
            axes = np.array([axes])
        axes_flat = axes.flatten() if isinstance(axes, np.ndarray) else [axes]

        for idx, instruction in enumerate(instructions):
            ax = axes_flat[idx]
            params = energy_params[instruction]
            alpha = params["alpha"]
            beta = params["beta"]

            # Plot gamma distribution
            y = gamma.pdf(x, a=alpha, scale=beta)

            ax.plot(x, y, linewidth=2, color="steelblue")
            ax.fill_between(x, y, alpha=0.3, color="steelblue")
            ax.set_title(f"{instruction}", fontweight="bold", fontsize=10)
            ax.set_xlabel("Cost (nJ)", fontsize=8)
            ax.set_ylabel("Density", fontsize=8)
            ax.grid(True, alpha=0.3, linestyle="--")
            ax.tick_params(labelsize=8)

            # Add statistics as text
            mean = alpha * beta
            ax.text(
                0.98,
                0.98,
                f"α={alpha:.2f}\nβ={beta:.2f}\nμ={mean:.2f}",
                transform=ax.transAxes,
                fontsize=7,
                verticalalignment="top",
                horizontalalignment="right",
                bbox={"boxstyle": "round", "facecolor": "wheat", "alpha": 0.5},
            )

        # Hide unused subplots
        for idx in range(num_instructions, len(axes_flat)):
            axes_flat[idx].axis("off")

        plt.tight_layout()

    if output_path:
        plt.savefig(output_path, dpi=300, bbox_inches="tight")
        print(f"Plot saved to: {output_path}")
    else:
        plt.show()


def parse_grid_layout(layout_str):
    """
    Parse grid layout string in format 'NxM' or 'NXM'.

    Args:
        layout_str: String in format 'NxM'

    Returns:
        Tuple of (rows, cols)
    """
    if not layout_str:
        return None, None

    parts = layout_str.lower().split("x")
    if len(parts) != 2:
        raise ValueError(
            f"Invalid grid layout format: {layout_str}. Expected format: NxM"
        )

    try:
        rows = int(parts[0])
        cols = int(parts[1])
        return rows, cols
    except ValueError:
        raise ValueError(
            f"Invalid grid layout format: {layout_str}. Expected integers."
        )


def main():
    parser = argparse.ArgumentParser(
        description="Plot instruction cost distributions from energy parameters JSON file.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s energy_params.json
  %(prog)s energy_params.json --grid 4x4
  %(prog)s energy_params.json --grid 3x5 --output instruction_costs.png
        """,
    )

    parser.add_argument(
        "filename", help="Path to JSON file containing energy parameters"
    )
    parser.add_argument(
        "--grid",
        "-g",
        help="Grid layout in format NxM (e.g., 4x4). If not specified, all distributions are plotted in a single frame.",
        default=None,
    )
    parser.add_argument(
        "--output",
        "-o",
        help="Output file path for saving the plot. Shows interactively if not specified.",
        default=None,
    )

    args = parser.parse_args()

    # Load energy parameters
    try:
        energy_params = load_energy_params(args.filename)
        print(f"Loaded {len(energy_params)} instructions from {args.filename}")
    except FileNotFoundError:
        print(f"Error: File '{args.filename}' not found.")
        return 1
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in '{args.filename}': {e}")
        return 1

    # Parse grid layout
    if args.grid is None:
        # Single frame mode
        rows, cols = None, None
        print("Plotting all distributions in a single frame")
    else:
        # Grid mode
        try:
            rows, cols = parse_grid_layout(args.grid)
            rows, cols = calculate_grid_layout(len(energy_params), rows, cols)
            print(f"Using grid layout: {rows}x{cols}")
        except ValueError as e:
            print(f"Error: {e}")
            return 1

    # Create plot
    plot_distributions(energy_params, rows, cols, args.output)

    return 0


if __name__ == "__main__":
    sys.exit(main())
