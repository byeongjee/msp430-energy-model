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
    with open(stats_file, 'r') as f:
        stats = json.load(f)
    return stats


def load_measured_data(csv_file):
    """Load measured energy data from CSV file."""
    df = pd.read_csv(csv_file)
    return df['energy_nJ'].values


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
    """Plot a histogram distribution."""
    fig, ax = plt.subplots(figsize=(8, 5), dpi=150)

    # Calculate optimal number of bins
    n_bins = min(100, max(30, int(np.ceil(np.sqrt(len(data))))))

    # Create histogram
    n, bins, patches = ax.hist(
        data, bins=n_bins, density=True,
        color=color, alpha=0.6, edgecolor=color, linewidth=1
    )

    # Add mean line
    mean_val = stats['mean'] if stats else np.mean(data)
    std_val = stats['std'] if stats else np.std(data, ddof=1)

    ax.axvline(mean_val, color='red', linewidth=2.5, linestyle='-',
               label=f'Mean: {mean_val:.2f} nJ')

    # Add text annotation
    y_max = n.max()
    ax.text(mean_val, y_max * 0.9, f'σ={std_val:.2f} nJ',
            fontsize=8, color='red',
            ha='center', va='top')

    ax.set_xlabel('Energy (nJ)', fontsize=10)
    ax.set_ylabel('Probability Density', fontsize=10)
    ax.set_title(title, fontsize=12, fontweight='bold')
    ax.legend(loc='upper right', fontsize=9)
    ax.grid(True, alpha=0.3, linestyle='--')

    plt.tight_layout()
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"  - Saved: {output_path}")


def plot_comparison(estimated_data, measured_data, estimated_stats, measured_stats, output_path):
    """Plot side-by-side comparison of estimated and measured distributions."""
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5), dpi=150)

    # Calculate optimal number of bins
    n_bins_est = min(100, max(30, int(np.ceil(np.sqrt(len(estimated_data))))))
    n_bins_meas = min(100, max(30, int(np.ceil(np.sqrt(len(measured_data))))))

    # Estimated distribution
    n1, bins1, _ = ax1.hist(
        estimated_data, bins=n_bins_est, density=True,
        color='steelblue', alpha=0.6, edgecolor='steelblue', linewidth=1
    )
    ax1.axvline(estimated_stats['mean'], color='red', linewidth=2.5, linestyle='-',
                label=f'Mean: {estimated_stats["mean"]:.2f} nJ')
    ax1.text(estimated_stats['mean'], n1.max() * 0.9, f'σ={estimated_stats["std"]:.2f} nJ',
             fontsize=8, color='red', ha='center', va='top')
    ax1.set_xlabel('Energy (nJ)', fontsize=10)
    ax1.set_ylabel('Probability Density', fontsize=10)
    ax1.set_title('Estimated Energy Distribution', fontsize=12, fontweight='bold')
    ax1.legend(loc='upper right', fontsize=9)
    ax1.grid(True, alpha=0.3, linestyle='--')

    # Measured distribution
    n2, bins2, _ = ax2.hist(
        measured_data, bins=n_bins_meas, density=True,
        color='green', alpha=0.6, edgecolor='green', linewidth=1
    )
    ax2.axvline(measured_stats['mean'], color='red', linewidth=2.5, linestyle='-',
                label=f'Mean: {measured_stats["mean"]:.2f} nJ')
    ax2.text(measured_stats['mean'], n2.max() * 0.9, f'σ={measured_stats["std"]:.2f} nJ',
             fontsize=8, color='red', ha='center', va='top')
    ax2.set_xlabel('Energy (nJ)', fontsize=10)
    ax2.set_ylabel('Probability Density', fontsize=10)
    ax2.set_title('Measured Energy Distribution', fontsize=12, fontweight='bold')
    ax2.legend(loc='upper right', fontsize=9)
    ax2.grid(True, alpha=0.3, linestyle='--')

    fig.suptitle('Estimated vs Measured Energy Consumption', fontsize=14, fontweight='bold', y=1.02)
    plt.tight_layout()
    plt.savefig(output_path, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"  - Saved: {output_path}")


def generate_text_report(estimated_stats, measured_stats, report_path):
    """Generate text comparison report."""
    # Calculate comparison metrics
    mean_diff = estimated_stats['mean'] - measured_stats['mean']
    mean_diff_pct = (mean_diff / measured_stats['mean']) * 100
    std_diff = estimated_stats['std'] - measured_stats['std']
    std_diff_pct = (std_diff / measured_stats['std']) * 100

    # Determine assessment
    if abs(mean_diff_pct) < 5:
        assessment = "Excellent agreement (< 5% error)"
    elif abs(mean_diff_pct) < 10:
        assessment = "Good agreement (< 10% error)"
    elif abs(mean_diff_pct) < 20:
        assessment = "Moderate agreement (< 20% error)"
    else:
        assessment = "Significant deviation (≥ 20% error)"

    # Write report
    with open(report_path, 'w') as f:
        f.write("=" * 80 + "\n")
        f.write("Energy Consumption Comparison Report\n")
        f.write("=" * 80 + "\n\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")

        f.write("-" * 80 + "\n")
        f.write("ESTIMATED DISTRIBUTION (from probabilistic model)\n")
        f.write("-" * 80 + "\n")
        f.write(f"  Mean:             {estimated_stats['mean']:.4f} nJ\n")
        f.write(f"  Std Deviation:    {estimated_stats['std']:.4f} nJ\n")
        f.write(f"  Min:              {estimated_stats['min']:.4f} nJ\n")
        f.write(f"  Max:              {estimated_stats['max']:.4f} nJ\n")
        f.write(f"  Samples:          {estimated_stats['count']}\n\n")

        f.write("-" * 80 + "\n")
        f.write("MEASURED DISTRIBUTION (from hardware)\n")
        f.write("-" * 80 + "\n")
        f.write(f"  Mean:             {measured_stats['mean']:.4f} nJ\n")
        f.write(f"  Std Deviation:    {measured_stats['std']:.4f} nJ\n")
        f.write(f"  Min:              {measured_stats['min']:.4f} nJ\n")
        f.write(f"  Max:              {measured_stats['max']:.4f} nJ\n")
        f.write(f"  Samples:          {measured_stats['count']}\n\n")

        f.write("-" * 80 + "\n")
        f.write("COMPARISON\n")
        f.write("-" * 80 + "\n")
        f.write(f"  Mean Difference:       {mean_diff:.4f} nJ\n")
        f.write(f"  Mean Error:            {mean_diff_pct:.2f}%\n")
        f.write(f"  Std Dev Difference:    {std_diff:.4f} nJ\n")
        f.write(f"  Std Dev Error:         {std_diff_pct:.2f}%\n\n")
        f.write(f"  Assessment: {assessment}\n\n")

        f.write("=" * 80 + "\n")
        f.write("Output Files:\n")
        f.write("  - estimated_distribution.png\n")
        f.write("  - measured_distribution.png\n")
        f.write("  - comparison_plot.png\n")
        f.write("  - comparison.txt (this file)\n")
        f.write("=" * 80 + "\n")

    print(f"  - Saved: {report_path}")
    return mean_diff_pct


def main():
    parser = argparse.ArgumentParser(
        description='Generate comparison report between estimated and measured energy distributions'
    )
    parser.add_argument('--estimated-stats', required=True, help='Path to estimated statistics JSON file')
    parser.add_argument('--measured-data', required=True, help='Path to measured segments CSV file')
    parser.add_argument('--report-dir', required=True, help='Directory for comparison report output')
    parser.add_argument('--num-repeat', type=int, required=True, help='NUM_REPEAT value used for measurements')

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
    measured_energies = load_measured_data(args.measured_data)

    # Extract all events from estimated stats
    events = estimated_stats_dict['events']
    num_events = len(events)
    num_repeat = args.num_repeat

    print(f"  Number of events: {num_events}")
    print(f"  NUM_REPEAT: {num_repeat}")
    print(f"  Total measurements expected: {num_events * num_repeat}")
    print(f"  Total measurements found: {len(measured_energies)}")
    print()

    # Validate measurement count
    if len(measured_energies) != num_events * num_repeat:
        print(f"ERROR: Expected {num_events * num_repeat} measurements but got {len(measured_energies)}")
        return 1

    # Process each event
    print("Processing events...")
    all_errors = []

    # Create combined text report
    report_path = report_dir / 'comparison.txt'
    with open(report_path, 'w') as f:
        f.write("=" * 80 + "\n")
        f.write("Energy Consumption Comparison Report\n")
        f.write("=" * 80 + "\n\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"Number of events: {num_events}\n")
        f.write(f"NUM_REPEAT: {num_repeat}\n\n")

        for event_idx, event_stats_dict in enumerate(events):
            print(f"\n  Event {event_idx + 1}/{num_events}")

            # Extract estimated data for this event
            estimated_data = np.array(event_stats_dict['samples'])
            estimated_stats = {
                'mean': event_stats_dict['mean'],
                'std': event_stats_dict['std'],
                'min': event_stats_dict['min'],
                'max': event_stats_dict['max'],
                'count': len(estimated_data)
            }

            # Extract measured data for this event (chunk of NUM_REPEAT measurements)
            start_idx = event_idx * num_repeat
            end_idx = start_idx + num_repeat
            measured_data_event = measured_energies[start_idx:end_idx]
            measured_stats = calculate_statistics(measured_data_event)

            print(f"    Estimated: {estimated_stats['count']} samples, mean={estimated_stats['mean']:.2f} nJ")
            print(f"    Measured:  {measured_stats['count']} samples, mean={measured_stats['mean']:.2f} nJ")

            # Calculate comparison metrics
            mean_diff = estimated_stats['mean'] - measured_stats['mean']
            mean_diff_pct = (mean_diff / measured_stats['mean']) * 100
            std_diff = estimated_stats['std'] - measured_stats['std']
            std_diff_pct = (std_diff / measured_stats['std']) * 100
            all_errors.append(mean_diff_pct)

            # Write to report
            f.write("=" * 80 + "\n")
            f.write(f"EVENT {event_idx + 1}\n")
            f.write("=" * 80 + "\n\n")

            f.write("-" * 80 + "\n")
            f.write("ESTIMATED DISTRIBUTION (from probabilistic model)\n")
            f.write("-" * 80 + "\n")
            f.write(f"  Mean:             {estimated_stats['mean']:.4f} nJ\n")
            f.write(f"  Std Deviation:    {estimated_stats['std']:.4f} nJ\n")
            f.write(f"  Min:              {estimated_stats['min']:.4f} nJ\n")
            f.write(f"  Max:              {estimated_stats['max']:.4f} nJ\n")
            f.write(f"  Samples:          {estimated_stats['count']}\n\n")

            f.write("-" * 80 + "\n")
            f.write("MEASURED DISTRIBUTION (from hardware)\n")
            f.write("-" * 80 + "\n")
            f.write(f"  Mean:             {measured_stats['mean']:.4f} nJ\n")
            f.write(f"  Std Deviation:    {measured_stats['std']:.4f} nJ\n")
            f.write(f"  Min:              {measured_stats['min']:.4f} nJ\n")
            f.write(f"  Max:              {measured_stats['max']:.4f} nJ\n")
            f.write(f"  Samples:          {measured_stats['count']}\n\n")

            f.write("-" * 80 + "\n")
            f.write("COMPARISON\n")
            f.write("-" * 80 + "\n")
            f.write(f"  Mean Difference:       {mean_diff:.4f} nJ\n")
            f.write(f"  Mean Error:            {mean_diff_pct:.2f}%\n")
            f.write(f"  Std Dev Difference:    {std_diff:.4f} nJ\n")
            f.write(f"  Std Dev Error:         {std_diff_pct:.2f}%\n\n")

            # Generate plots for this event
            plot_distribution(
                estimated_data, f'Estimated Energy Distribution - Event {event_idx + 1}',
                report_dir / f'event_{event_idx + 1}_estimated.png',
                color='steelblue', stats=estimated_stats
            )

            plot_distribution(
                measured_data_event, f'Measured Energy Distribution - Event {event_idx + 1}',
                report_dir / f'event_{event_idx + 1}_measured.png',
                color='green', stats=measured_stats
            )

            plot_comparison(
                estimated_data, measured_data_event,
                estimated_stats, measured_stats,
                report_dir / f'event_{event_idx + 1}_comparison.png'
            )

        # Write summary
        f.write("=" * 80 + "\n")
        f.write("SUMMARY\n")
        f.write("=" * 80 + "\n")
        f.write(f"Average absolute error: {np.mean(np.abs(all_errors)):.2f}%\n")
        f.write(f"Max absolute error: {np.max(np.abs(all_errors)):.2f}%\n\n")

        f.write("=" * 80 + "\n")
        f.write("Output Files:\n")
        for event_idx in range(num_events):
            f.write(f"  Event {event_idx + 1}:\n")
            f.write(f"    - event_{event_idx + 1}_estimated.png\n")
            f.write(f"    - event_{event_idx + 1}_measured.png\n")
            f.write(f"    - event_{event_idx + 1}_comparison.png\n")
        f.write("  - comparison.txt (this file)\n")
        f.write("=" * 80 + "\n")

    print(f"  - Saved: {report_path}")
    print()

    print("=" * 60)
    print("COMPARISON COMPLETE")
    print("=" * 60)
    print(f"Report location: {report_dir}")
    print(f"Average absolute error: {np.mean(np.abs(all_errors)):.2f}%")
    print("=" * 60)

    return 0


if __name__ == '__main__':
    sys.exit(main())
