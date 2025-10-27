#!/usr/bin/env python3
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import argparse
import os

# Set up command-line argument parser
parser = argparse.ArgumentParser(description="Analyze energy data from CSV file")
parser.add_argument("--input", required=True, help="Input CSV file path")
parser.add_argument("--output", required=True, help="Output PNG file path (base name)")
parser.add_argument("--num-repeat", type=int, required=True, help="Number of repetitions per event")
args = parser.parse_args()

# Read the CSV file
df = pd.read_csv(args.input)

# Calculate number of events
total_samples = len(df)
num_events = total_samples // args.num_repeat

if total_samples % args.num_repeat != 0:
    print(f"Warning: Total samples ({total_samples}) is not divisible by NUM_REPEAT ({args.num_repeat})")
    print(f"Will analyze {num_events} complete events and ignore the remaining {total_samples % args.num_repeat} samples")

print(f"Analysis Settings:")
print(f"  Total samples: {total_samples}")
print(f"  NUM_REPEAT: {args.num_repeat}")
print(f"  Number of events: {num_events}")
print()

# Get output directory and base name
output_dir = os.path.dirname(args.output)
output_base = os.path.splitext(os.path.basename(args.output))[0]

# Create summary statistics file
summary_file = os.path.join(output_dir, f"{output_base}_summary.csv")
summary_data = []

# Analyze each event
for event_idx in range(num_events):
    start_idx = event_idx * args.num_repeat
    end_idx = start_idx + args.num_repeat

    event_data = df.iloc[start_idx:end_idx]["energy_nJ"]

    # Calculate statistics
    mean_energy = event_data.mean()
    std_energy = event_data.std()
    min_energy = event_data.min()
    max_energy = event_data.max()

    print(f"Event {event_idx + 1} Statistics:")
    print(f"  Mean: {mean_energy:.2f} nJ")
    print(f"  Standard Deviation: {std_energy:.2f} nJ")
    print(f"  Min: {min_energy:.2f} nJ")
    print(f"  Max: {max_energy:.2f} nJ")
    print(f"  Number of samples: {len(event_data)}")
    print()

    # Save to summary
    summary_data.append({
        "event": event_idx + 1,
        "mean_nJ": mean_energy,
        "std_nJ": std_energy,
        "min_nJ": min_energy,
        "max_nJ": max_energy,
        "samples": len(event_data)
    })

    # Create visualization for this event
    fig, axes = plt.subplots(2, 1, figsize=(10, 8))

    # Plot 1: Scatter plot showing all data points
    axes[0].scatter(range(len(event_data)), event_data.values, alpha=0.6, s=30, color='blue')
    axes[0].axhline(
        y=mean_energy, color="r", linestyle="--", label=f"Mean: {mean_energy:.2f} nJ"
    )
    axes[0].axhline(
        y=mean_energy + std_energy,
        color="orange",
        linestyle=":",
        label=f"+1 SD: {mean_energy + std_energy:.2f} nJ",
    )
    axes[0].axhline(
        y=mean_energy - std_energy,
        color="orange",
        linestyle=":",
        label=f"-1 SD: {mean_energy - std_energy:.2f} nJ",
    )
    axes[0].set_xlabel("Sample Index")
    axes[0].set_ylabel("Energy (nJ)")
    axes[0].set_title(f"Event {event_idx + 1} - Energy Distribution Over Time")
    axes[0].legend()
    axes[0].grid(True, alpha=0.3)

    # Plot 2: Histogram to see distribution shape
    axes[1].hist(event_data.values, bins=min(30, len(event_data)//2), alpha=0.7, edgecolor="black", color='blue')
    axes[1].axvline(
        x=mean_energy,
        color="r",
        linestyle="--",
        linewidth=2,
        label=f"Mean: {mean_energy:.2f} nJ",
    )
    axes[1].axvline(x=mean_energy + std_energy, color="orange", linestyle=":", linewidth=2)
    axes[1].axvline(x=mean_energy - std_energy, color="orange", linestyle=":", linewidth=2)
    axes[1].set_xlabel("Energy (nJ)")
    axes[1].set_ylabel("Frequency")
    axes[1].set_title(f"Event {event_idx + 1} - Energy Distribution Histogram")
    axes[1].legend()
    axes[1].grid(True, alpha=0.3)

    plt.tight_layout()

    # Save plot for this event
    event_output = os.path.join(output_dir, f"{output_base}_event_{event_idx + 1}.png")
    plt.savefig(event_output, dpi=300, bbox_inches="tight")
    plt.close()

    print(f"  Plot saved: {event_output}")

# Save summary CSV
summary_df = pd.DataFrame(summary_data)
summary_df.to_csv(summary_file, index=False)
print()
print(f"Summary saved: {summary_file}")
print()
print("Analysis complete!")
