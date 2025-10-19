#!/usr/bin/env python3
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import argparse

# Set up command-line argument parser
parser = argparse.ArgumentParser(description="Analyze energy data from CSV file")
parser.add_argument("--input", help="Input CSV file path")
parser.add_argument("--output", help="Output PNG file path")
args = parser.parse_args()

# Read the CSV file
df = pd.read_csv(args.input)

# Calculate statistics
mean_energy = df["energy_nJ"].mean()
std_energy = df["energy_nJ"].std()

print(f"Energy Statistics:")
print(f"Mean: {mean_energy:.2f} nJ")
print(f"Standard Deviation: {std_energy:.2f} nJ")
print(f"Min: {df['energy_nJ'].min():.2f} nJ")
print(f"Max: {df['energy_nJ'].max():.2f} nJ")
print(f"Number of samples: {len(df)}")

# Create visualization
fig, axes = plt.subplots(2, 1, figsize=(10, 8))

# Plot 1: Scatter plot showing all data points
axes[0].scatter(range(len(df)), df["energy_nJ"], alpha=0.6, s=30)
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
axes[0].set_title("Energy Distribution Over Time")
axes[0].legend()
axes[0].grid(True, alpha=0.3)

# Plot 2: Histogram to see distribution shape
axes[1].hist(df["energy_nJ"], bins=30, alpha=0.7, edgecolor="black")
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
axes[1].set_title("Energy Distribution Histogram")
axes[1].legend()
axes[1].grid(True, alpha=0.3)

plt.tight_layout()
if args.output is not None:
    plt.savefig(args.output, dpi=300, bbox_inches="tight")
else:
    plt.show()

print(f"\nPlot saved as '{args.output}'")
