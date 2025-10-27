#!/usr/bin/env python3
"""
Generate energy distribution analysis report.
Reads segments CSV, groups by NUM_REPEAT, generates plots and markdown report.
"""

import argparse
import sys
from datetime import datetime
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


def calculate_statistics(data):
    """Calculate statistics for a dataset."""
    return {
        'mean': np.mean(data),
        'std': np.std(data, ddof=1),
        'min': np.min(data),
        'max': np.max(data),
        'count': len(data)
    }


def plot_distribution(data, title, output_path, color='steelblue', stats=None):
    """Plot a histogram distribution with scatter plot."""
    fig, axes = plt.subplots(2, 1, figsize=(10, 8), dpi=150)

    # Plot 1: Scatter plot showing all data points
    axes[0].scatter(range(len(data)), data, alpha=0.6, s=30, color=color)

    if stats:
        mean = stats['mean']
        std = stats['std']
        axes[0].axhline(y=mean, color='r', linestyle='--',
                       label=f"Mean: {mean:.2f} nJ", linewidth=2)
        axes[0].axhline(y=mean + std, color='orange', linestyle=':',
                       label=f"+1 SD: {mean + std:.2f} nJ", linewidth=2)
        axes[0].axhline(y=mean - std, color='orange', linestyle=':',
                       label=f"-1 SD: {mean - std:.2f} nJ", linewidth=2)

    axes[0].set_xlabel("Sample Index")
    axes[0].set_ylabel("Energy (nJ)")
    axes[0].set_title(f"{title} - Over Time")
    axes[0].legend()
    axes[0].grid(True, alpha=0.3)

    # Plot 2: Histogram
    if len(data) > 2:
        q75, q25 = np.percentile(data, [75, 25])
        iqr = q75 - q25
        if iqr > 0:
            bin_width = 2 * iqr / (len(data) ** (1/3))
            bins = int(np.ceil((data.max() - data.min()) / bin_width))
            bins = max(10, min(bins, 50))
        else:
            bins = 20
    else:
        bins = 10

    axes[1].hist(data, bins=bins, alpha=0.7, edgecolor='black', color=color)

    if stats:
        mean = stats['mean']
        std = stats['std']
        axes[1].axvline(x=mean, color='r', linestyle='--', linewidth=2,
                       label=f"Mean: {mean:.2f} nJ")
        axes[1].axvline(x=mean + std, color='orange', linestyle=':', linewidth=2)
        axes[1].axvline(x=mean - std, color='orange', linestyle=':', linewidth=2)

    axes[1].set_xlabel("Energy (nJ)")
    axes[1].set_ylabel("Frequency")
    axes[1].set_title(f"{title} - Histogram")
    axes[1].legend()
    axes[1].grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.close()


def main():
    parser = argparse.ArgumentParser(
        description='Generate energy distribution analysis report'
    )
    parser.add_argument('--segments-csv', required=True,
                       help='Path to segments CSV file')
    parser.add_argument('--num-repeat', type=int, required=True,
                       help='Number of repetitions per event')
    parser.add_argument('--report-dir', required=True,
                       help='Directory to save report and plots')
    parser.add_argument('--file-name', required=True,
                       help='Name of the C file being analyzed')

    args = parser.parse_args()

    # Convert to Path objects
    segments_path = Path(args.segments_csv)
    report_dir = Path(args.report_dir)

    # Validate inputs
    if not segments_path.exists():
        print(f"Error: Segments file not found: {segments_path}", file=sys.stderr)
        sys.exit(1)

    # Create report directory
    report_dir.mkdir(parents=True, exist_ok=True)

    print(f"Generating distribution analysis report...")
    print(f"  Segments CSV: {segments_path}")
    print(f"  NUM_REPEAT: {args.num_repeat}")
    print(f"  Report directory: {report_dir}")

    # Load measured data
    df = pd.read_csv(segments_path)
    all_energies = df['energy_nJ'].values

    # Calculate number of events
    total_samples = len(all_energies)
    num_events = total_samples // args.num_repeat

    if total_samples % args.num_repeat != 0:
        print(f"Warning: Total samples ({total_samples}) is not divisible by NUM_REPEAT ({args.num_repeat})")
        print(f"Will analyze {num_events} complete events and ignore the remaining {total_samples % args.num_repeat} samples")

    print(f"  Total samples: {total_samples}")
    print(f"  Number of events: {num_events}")
    print()

    # Prepare summary data
    summary_data = []

    # Generate markdown report
    report_path = report_dir / 'distribution_analysis.md'
    with open(report_path, 'w') as f:
        f.write("# Energy Distribution Analysis Report\n\n")
        f.write(f"**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}  \n")
        f.write(f"**File:** `{args.file_name}`  \n")
        f.write(f"**Number of events:** {num_events}  \n")
        f.write(f"**NUM_REPEAT:** {args.num_repeat}  \n")
        f.write(f"**Total samples:** {total_samples}\n\n")
        f.write("---\n\n")

        # Process each event
        for event_idx in range(num_events):
            start_idx = event_idx * args.num_repeat
            end_idx = start_idx + args.num_repeat

            event_data = all_energies[start_idx:end_idx]
            stats = calculate_statistics(event_data)

            print(f"  Processing Event {event_idx + 1}/{num_events}")
            print(f"    Mean: {stats['mean']:.2f} nJ, Std: {stats['std']:.2f} nJ")

            # Save to summary
            summary_data.append({
                'event': event_idx + 1,
                'mean_nJ': stats['mean'],
                'std_nJ': stats['std'],
                'min_nJ': stats['min'],
                'max_nJ': stats['max'],
                'samples': stats['count']
            })

            # Write to markdown report
            f.write(f"## Event {event_idx + 1}\n\n")

            # Statistics table
            f.write("### Statistics\n\n")
            f.write("| Metric | Value |\n")
            f.write("|--------|------:|\n")
            f.write(f"| **Mean** | {stats['mean']:.4f} nJ |\n")
            f.write(f"| **Std Dev** | {stats['std']:.4f} nJ |\n")
            f.write(f"| **CV** | {(stats['std']/stats['mean']*100):.2f}% |\n")
            f.write(f"| **Min** | {stats['min']:.4f} nJ |\n")
            f.write(f"| **Max** | {stats['max']:.4f} nJ |\n")
            f.write(f"| **Range** | {stats['max'] - stats['min']:.4f} nJ |\n")
            f.write(f"| **Samples** | {stats['count']} |\n\n")

            # Distribution plot
            f.write("### Distribution\n\n")
            f.write(f"![Event {event_idx + 1} Distribution](event_{event_idx + 1}_distribution.png)\n\n")
            f.write("---\n\n")

            # Generate plot for this event
            plot_distribution(
                event_data,
                f'Event {event_idx + 1} Energy Distribution',
                report_dir / f'event_{event_idx + 1}_distribution.png',
                color='steelblue',
                stats=stats
            )

        # Write summary section
        f.write("## Summary\n\n")
        f.write("### All Events Statistics\n\n")
        f.write("| Event | Mean (nJ) | Std Dev (nJ) | CV (%) | Min (nJ) | Max (nJ) | Samples |\n")
        f.write("|------:|----------:|-------------:|-------:|---------:|---------:|--------:|\n")

        for event_summary in summary_data:
            cv = (event_summary['std_nJ'] / event_summary['mean_nJ'] * 100) if event_summary['mean_nJ'] > 0 else 0
            f.write(f"| {event_summary['event']} | "
                   f"{event_summary['mean_nJ']:.4f} | "
                   f"{event_summary['std_nJ']:.4f} | "
                   f"{cv:.2f} | "
                   f"{event_summary['min_nJ']:.4f} | "
                   f"{event_summary['max_nJ']:.4f} | "
                   f"{event_summary['samples']} |\n")

        # Overall statistics
        all_means = [s['mean_nJ'] for s in summary_data]
        all_stds = [s['std_nJ'] for s in summary_data]

        f.write("\n### Across All Events\n\n")
        f.write("| Metric | Value |\n")
        f.write("|--------|------:|\n")
        f.write(f"| **Average Mean** | {np.mean(all_means):.4f} nJ |\n")
        f.write(f"| **Average Std Dev** | {np.mean(all_stds):.4f} nJ |\n")
        f.write(f"| **Mean Variability (Std of Means)** | {np.std(all_means, ddof=1):.4f} nJ |\n")
        f.write(f"| **Total Events** | {num_events} |\n\n")

        f.write("### Output Files\n\n")
        f.write("```\n")
        for event_idx in range(num_events):
            f.write(f"Event {event_idx + 1}:\n")
            f.write(f"  - event_{event_idx + 1}_distribution.png\n")
        f.write("segments.csv (preprocessed data)\n")
        f.write("distribution_summary.csv (statistics summary)\n")
        f.write("distribution_analysis.md (this file)\n")
        f.write("```\n")

    # Save summary CSV
    summary_df = pd.DataFrame(summary_data)
    summary_csv_path = report_dir / 'distribution_summary.csv'
    summary_df.to_csv(summary_csv_path, index=False)

    print()
    print(f"✓ Report generated: {report_path}")
    print(f"✓ Summary CSV saved: {summary_csv_path}")
    print(f"✓ {num_events} distribution plots generated")
    print()
    print("Report generation complete!")


if __name__ == '__main__':
    main()
