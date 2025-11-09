#!/usr/bin/env python3
"""
Generate comparison report between estimated and measured energy distributions.
Reads estimated statistics JSON and measured segments CSV, generates plots and text report.
"""

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


def load_estimated_stats(stats_file):
    """Load estimated statistics from JSON file."""
    with open(stats_file, "r") as f:
        stats = json.load(f)
    return stats


def load_measured_data(csv_file):
    """Load measured energy data and event labels from CSV file."""
    df = pd.read_csv(csv_file)
    energy = df["energy_nJ"].values
    event_labels = df["event_label"].values if "event_label" in df.columns else None
    return energy, event_labels


def calculate_statistics(data):
    """Calculate statistics for a dataset."""
    return {
        "mean": np.mean(data),
        "std": np.std(data, ddof=1),
        "min": np.min(data),
        "max": np.max(data),
        "count": len(data),
    }


def plot_distribution(data, title, output_path, color="steelblue", stats=None):
    """Plot a histogram distribution."""
    fig, ax = plt.subplots(figsize=(8, 5), dpi=150)

    # Calculate optimal number of bins using Freedman-Diaconis rule
    # This works better for varying sample sizes
    if len(data) > 2:
        q75, q25 = np.percentile(data, [75, 25])
        iqr = q75 - q25
        if iqr > 0:
            bin_width = 2 * iqr / (len(data) ** (1 / 3))
            n_bins = int(np.ceil((data.max() - data.min()) / bin_width))
            # Constrain to reasonable range
            n_bins = min(100, max(10, n_bins))
        else:
            # Fallback if IQR is 0
            n_bins = min(30, max(10, len(data) // 2))
    else:
        n_bins = 10

    # Create histogram
    n, bins, patches = ax.hist(
        data,
        bins=n_bins,
        density=True,
        color=color,
        alpha=0.6,
        edgecolor=color,
        linewidth=1,
    )

    # Add mean line
    mean_val = stats["mean"] if stats else np.mean(data)
    std_val = stats["std"] if stats else np.std(data, ddof=1)

    ax.axvline(
        mean_val,
        color="red",
        linewidth=2.5,
        linestyle="-",
        label=f"Mean: {mean_val:.2f} nJ",
    )

    # Add text annotation
    y_max = n.max()
    ax.text(
        mean_val,
        y_max * 0.9,
        f"σ={std_val:.2f} nJ",
        fontsize=8,
        color="red",
        ha="center",
        va="top",
    )

    ax.set_xlabel("Energy (nJ)", fontsize=10)
    ax.set_ylabel("Probability Density", fontsize=10)
    ax.set_title(title, fontsize=12, fontweight="bold")
    ax.legend(loc="upper right", fontsize=9)
    ax.grid(True, alpha=0.3, linestyle="--")

    plt.tight_layout()
    plt.savefig(output_path, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"  - Saved: {output_path}")


def plot_comparison(
    estimated_data, measured_data, estimated_stats, measured_stats, output_path
):
    """Plot side-by-side comparison of estimated and measured distributions."""
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5), dpi=150)

    # Calculate optimal number of bins using Freedman-Diaconis rule
    def calculate_bins(data):
        if len(data) > 2:
            q75, q25 = np.percentile(data, [75, 25])
            iqr = q75 - q25
            if iqr > 0:
                bin_width = 2 * iqr / (len(data) ** (1 / 3))
                n_bins = int(np.ceil((data.max() - data.min()) / bin_width))
                return min(100, max(10, n_bins))
            else:
                return min(30, max(10, len(data) // 2))
        return 10

    n_bins_est = calculate_bins(estimated_data)
    n_bins_meas = calculate_bins(measured_data)

    # Estimated distribution
    n1, bins1, _ = ax1.hist(
        estimated_data,
        bins=n_bins_est,
        density=True,
        color="steelblue",
        alpha=0.6,
        edgecolor="steelblue",
        linewidth=1,
    )
    ax1.axvline(
        estimated_stats["mean"],
        color="red",
        linewidth=2.5,
        linestyle="-",
        label=f'Mean: {estimated_stats["mean"]:.2f} nJ',
    )
    ax1.text(
        estimated_stats["mean"],
        n1.max() * 0.9,
        f'σ={estimated_stats["std"]:.2f} nJ',
        fontsize=8,
        color="red",
        ha="center",
        va="top",
    )
    ax1.set_xlabel("Energy (nJ)", fontsize=10)
    ax1.set_ylabel("Probability Density", fontsize=10)
    ax1.set_title("Estimated Energy Distribution", fontsize=12, fontweight="bold")
    ax1.legend(loc="upper right", fontsize=9)
    ax1.grid(True, alpha=0.3, linestyle="--")

    # Measured distribution
    n2, bins2, _ = ax2.hist(
        measured_data,
        bins=n_bins_meas,
        density=True,
        color="green",
        alpha=0.6,
        edgecolor="green",
        linewidth=1,
    )
    ax2.axvline(
        measured_stats["mean"],
        color="red",
        linewidth=2.5,
        linestyle="-",
        label=f'Mean: {measured_stats["mean"]:.2f} nJ',
    )
    ax2.text(
        measured_stats["mean"],
        n2.max() * 0.9,
        f'σ={measured_stats["std"]:.2f} nJ',
        fontsize=8,
        color="red",
        ha="center",
        va="top",
    )
    ax2.set_xlabel("Energy (nJ)", fontsize=10)
    ax2.set_ylabel("Probability Density", fontsize=10)
    ax2.set_title("Measured Energy Distribution", fontsize=12, fontweight="bold")
    ax2.legend(loc="upper right", fontsize=9)
    ax2.grid(True, alpha=0.3, linestyle="--")

    fig.suptitle(
        "Estimated vs Measured Energy Consumption",
        fontsize=14,
        fontweight="bold",
        y=1.02,
    )
    plt.tight_layout()
    plt.savefig(output_path, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"  - Saved: {output_path}")


def main():
    parser = argparse.ArgumentParser(
        description="Generate comparison report between estimated and measured energy distributions"
    )
    parser.add_argument(
        "--estimated-stats",
        required=True,
        help="Path to estimated statistics JSON file",
    )
    parser.add_argument(
        "--measured-data", required=True, help="Path to measured segments CSV file"
    )
    parser.add_argument(
        "--report-dir", required=True, help="Directory for comparison report output"
    )
    parser.add_argument(
        "--num-repeat",
        type=int,
        required=True,
        help="NUM_REPEAT value used for measurements",
    )

    args = parser.parse_args()

    print("=" * 60)
    print("Generating Comparison Report")
    print("=" * 60)
    print(f"Estimated stats: {args.estimated_stats}")
    print(f"Measured data:   {args.measured_data}")
    print(f"Report dir:      {args.report_dir}")
    print(f"NUM_REPEAT:      {args.num_repeat}")
    print()

    # Create report directory
    report_dir = Path(args.report_dir)
    report_dir.mkdir(parents=True, exist_ok=True)

    # Load data
    print("Loading data...")
    estimated_stats_dict = load_estimated_stats(args.estimated_stats)
    measured_energies, event_labels = load_measured_data(args.measured_data)

    # Extract all events from estimated stats
    events = estimated_stats_dict["events"]
    num_events = len(events)
    num_repeat = args.num_repeat

    print(f"  Number of events: {num_events}")
    print(f"  NUM_REPEAT: {num_repeat}")
    print(f"  Total measurements expected: {num_events * num_repeat}")
    print(f"  Total measurements found: {len(measured_energies)}")
    print()

    # Validate measurement count
    if len(measured_energies) != num_events * num_repeat:
        print(
            f"ERROR: Expected {num_events * num_repeat} measurements but got {len(measured_energies)}"
        )
        return 1

    # Process each event
    print("Processing events...")
    all_errors = []

    # Create combined markdown report
    report_path = report_dir / "comparison.md"
    with open(report_path, "w") as f:
        f.write("# Energy Consumption Comparison Report\n\n")
        f.write(f"**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}  \n")
        f.write(f"**Number of events:** {num_events}  \n")
        f.write(f"**NUM_REPEAT:** {num_repeat}\n\n")
        f.write("---\n\n")

        for event_idx, event_stats_dict in enumerate(events):
            # Extract measured data for this event (chunk of NUM_REPEAT measurements)
            start_idx = event_idx * num_repeat
            end_idx = start_idx + num_repeat
            measured_data_event = measured_energies[start_idx:end_idx]

            # Get event label if available
            event_label = event_labels[start_idx] if event_labels is not None else None
            # Use just the label if available, otherwise use index
            filename_prefix = event_label if event_label else f"event_{event_idx + 1}"

            print(
                f"\n  {event_label if event_label else f'Event {event_idx + 1}'} ({event_idx + 1}/{num_events})"
            )

            # Extract estimated data for this event
            estimated_data = np.array(event_stats_dict["samples"])
            estimated_stats = {
                "mean": event_stats_dict["mean"],
                "std": event_stats_dict["std"],
                "min": event_stats_dict["min"],
                "max": event_stats_dict["max"],
                "count": len(estimated_data),
            }

            measured_stats = calculate_statistics(measured_data_event)

            print(
                f"    Estimated: {estimated_stats['count']} samples, mean={estimated_stats['mean']:.2f} nJ"
            )
            print(
                f"    Measured:  {measured_stats['count']} samples, mean={measured_stats['mean']:.2f} nJ"
            )

            # Calculate comparison metrics
            mean_diff = estimated_stats["mean"] - measured_stats["mean"]
            mean_diff_pct = (mean_diff / measured_stats["mean"]) * 100
            std_diff = estimated_stats["std"] - measured_stats["std"]
            std_diff_pct = (std_diff / measured_stats["std"]) * 100
            all_errors.append(mean_diff_pct)

            # Write to report
            f.write(f"## {filename_prefix}\n\n")

            # Statistics table
            f.write("### Statistics\n\n")
            f.write(
                "| Metric | Estimated (Model) | Measured (Hardware) | Difference | Error |\n"
            )
            f.write(
                "|--------|------------------|--------------------|-----------:|------:|\n"
            )
            f.write(
                f"| **Mean** | {estimated_stats['mean']:.4f} nJ | {measured_stats['mean']:.4f} nJ | {mean_diff:.4f} nJ | {mean_diff_pct:.2f}% |\n"
            )
            f.write(
                f"| **Std Dev** | {estimated_stats['std']:.4f} nJ | {measured_stats['std']:.4f} nJ | {std_diff:.4f} nJ | {std_diff_pct:.2f}% |\n"
            )
            f.write(
                f"| **Min** | {estimated_stats['min']:.4f} nJ | {measured_stats['min']:.4f} nJ | - | - |\n"
            )
            f.write(
                f"| **Max** | {estimated_stats['max']:.4f} nJ | {measured_stats['max']:.4f} nJ | - | - |\n"
            )
            f.write(
                f"| **Samples** | {estimated_stats['count']} | {measured_stats['count']} | - | - |\n\n"
            )

            # Plots
            f.write("### Distributions\n\n")
            f.write("#### Comparison\n\n")
            f.write(
                f"![Event {event_idx + 1} Comparison]({filename_prefix}_comparison.png)\n\n"
            )

            f.write("#### Estimated Distribution\n\n")
            f.write(
                f"![Event {event_idx + 1} Estimated]({filename_prefix}_estimated.png)\n\n"
            )

            f.write("#### Measured Distribution\n\n")
            f.write(
                f"![Event {event_idx + 1} Measured]({filename_prefix}_measured.png)\n\n"
            )

            f.write("---\n\n")

            # Generate plots for this event
            plot_distribution(
                estimated_data,
                f"Estimated Energy Distribution - {filename_prefix}",
                report_dir / f"{filename_prefix}_estimated.png",
                color="steelblue",
                stats=estimated_stats,
            )

            plot_distribution(
                measured_data_event,
                f"Measured Energy Distribution - {filename_prefix}",
                report_dir / f"{filename_prefix}_measured.png",
                color="green",
                stats=measured_stats,
            )

            plot_comparison(
                estimated_data,
                measured_data_event,
                estimated_stats,
                measured_stats,
                report_dir / f"{filename_prefix}_comparison.png",
            )

        # Write summary
        f.write("## Summary\n\n")
        f.write("| Metric | Value |\n")
        f.write("|--------|------:|\n")
        f.write(
            f"| **Average Absolute Error** | {np.mean(np.abs(all_errors)):.2f}% |\n"
        )
        f.write(f"| **Max Absolute Error** | {np.max(np.abs(all_errors)):.2f}% |\n")
        f.write(f"| **Number of Events** | {num_events} |\n\n")

        f.write("### Output Files\n\n")
        f.write("```\n")
        for event_idx in range(num_events):
            event_label = (
                event_labels[event_idx * num_repeat]
                if event_labels is not None
                else None
            )
            filename_prefix = event_label if event_label else f"event_{event_idx + 1}"
            f.write(f"{filename_prefix}:\n")
            f.write(f"  - {filename_prefix}_estimated.png\n")
            f.write(f"  - {filename_prefix}_measured.png\n")
            f.write(f"  - {filename_prefix}_comparison.png\n")
        f.write("comparison.md (this file)\n")
        f.write("```\n")

    print(f"  - Saved: {report_path}")
    print()

    print("=" * 60)
    print("COMPARISON COMPLETE")
    print("=" * 60)
    print(f"Report location: {report_dir}")
    print(f"Average absolute error: {np.mean(np.abs(all_errors)):.2f}%")
    print("=" * 60)

    return 0


if __name__ == "__main__":
    sys.exit(main())
