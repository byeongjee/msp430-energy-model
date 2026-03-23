#!/usr/bin/env python3
"""
Compute checkpoint insertion parameters from measurement data.

Usage:
    uv run python report/checkpoint_params/compute_parameters.py <segments_csv>

Example:
    uv run python report/checkpoint_params/compute_parameters.py \
        report/checkpoint_params/analyze_distribution/20260323_164609/segments.csv

Outputs three parameters:
    - nvm_access_penalty:         max(|nvm_read - vm_read|, |nvm_write - vm_write|) per access
    - mem_store_energy_per_byte:  per-byte cost of SRAM -> FRAM copy
    - mem_restore_energy_per_byte: per-byte cost of FRAM -> SRAM copy
"""

import argparse

import numpy as np
import pandas as pd


def compute_parameters(segments_csv: str, inner_iters: int, textual_rept: int):
    df = pd.read_csv(segments_csv)

    # Group by event_label and compute mean energy per event
    means = df.groupby("event_label")["energy_nJ"].mean()

    # --- NVM Access Penalty ---
    reads_per_event = inner_iters * textual_rept * 3  # 3 reads per .rept body
    writes_per_event = inner_iters * textual_rept  # 1 write per .rept body

    required_labels = [
        "bench_sram_read",
        "bench_fram_read_miss",
        "bench_sram_write",
        "bench_fram_write",
    ]
    missing = [l for l in required_labels if l not in means.index]
    if missing:
        print(f"Warning: missing events for nvm_access_penalty: {missing}")
        print("Skipping nvm_access_penalty computation.")
        nvm_access_penalty = None
    else:
        sram_read_per = means["bench_sram_read"] / reads_per_event
        fram_read_per = means["bench_fram_read_miss"] / reads_per_event
        sram_write_per = means["bench_sram_write"] / writes_per_event
        fram_write_per = means["bench_fram_write"] / writes_per_event

        read_penalty = abs(fram_read_per - sram_read_per)
        write_penalty = abs(fram_write_per - sram_write_per)
        nvm_access_penalty = max(read_penalty, write_penalty)

        print("=== NVM Access Penalty ===")
        print(f"  SRAM read:       {sram_read_per:.4f} nJ/access")
        print(f"  FRAM read (miss):{fram_read_per:.4f} nJ/access")
        print(f"  SRAM write:      {sram_write_per:.4f} nJ/access")
        print(f"  FRAM write:      {fram_write_per:.4f} nJ/access")
        print(f"  |read penalty|:  {read_penalty:.4f} nJ/access")
        print(f"  |write penalty|: {write_penalty:.4f} nJ/access")
        print(f"  nvm_access_penalty = {nvm_access_penalty:.4f} nJ/access")
        print()

    # --- Memory Copy Energy ---
    copy_sizes = [2, 8, 32, 64, 128, 256]

    for direction, prefix in [("store", "bench_store_"), ("restore", "bench_restore_")]:
        labels = [f"{prefix}{s}" for s in copy_sizes]
        missing = [l for l in labels if l not in means.index]
        if missing:
            print(f"Warning: missing events for mem_{direction}: {missing}")
            print(f"Skipping mem_{direction}_energy_per_byte computation.")
            continue

        sizes = np.array(copy_sizes, dtype=float)
        energies_per_copy = np.array(
            [means[f"{prefix}{s}"] / inner_iters for s in copy_sizes]
        )

        # Linear regression: energy = slope * size + intercept
        slope, intercept = np.polyfit(sizes, energies_per_copy, 1)

        # R²
        predicted = slope * sizes + intercept
        ss_res = np.sum((energies_per_copy - predicted) ** 2)
        ss_tot = np.sum((energies_per_copy - np.mean(energies_per_copy)) ** 2)
        r_squared = 1 - ss_res / ss_tot

        dir_label = "SRAM -> FRAM" if direction == "store" else "FRAM -> SRAM"
        print(f"=== Memory {direction.title()} Energy ({dir_label}) ===")
        print(f"  Per-copy energy (nJ):")
        for s, e in zip(copy_sizes, energies_per_copy):
            print(f"    {s:>4d} bytes: {e:.2f} nJ")
        print(f"  Linear fit: energy = {slope:.4f} * bytes + {intercept:.4f}")
        print(f"  R² = {r_squared:.6f}")
        print(f"  mem_{direction}_energy_per_byte = {slope:.4f} nJ/byte")
        print()

    # --- Summary ---
    store_labels = [f"bench_store_{s}" for s in copy_sizes]
    restore_labels = [f"bench_restore_{s}" for s in copy_sizes]
    has_store = all(l in means.index for l in store_labels)
    has_restore = all(l in means.index for l in restore_labels)

    print("=== SUMMARY ===")
    if nvm_access_penalty is not None:
        print(f"  nvm_access_penalty         = {nvm_access_penalty:.4f} nJ/access")
    if has_store:
        sizes = np.array(copy_sizes, dtype=float)
        store_e = np.array([means[l] / inner_iters for l in store_labels])
        slope_s, _ = np.polyfit(sizes, store_e, 1)
        print(f"  mem_store_energy_per_byte   = {slope_s:.4f} nJ/byte")
    if has_restore:
        sizes = np.array(copy_sizes, dtype=float)
        restore_e = np.array([means[l] / inner_iters for l in restore_labels])
        slope_r, _ = np.polyfit(sizes, restore_e, 1)
        print(f"  mem_restore_energy_per_byte = {slope_r:.4f} nJ/byte")


def main():
    parser = argparse.ArgumentParser(
        description="Compute checkpoint insertion energy parameters from measurement data."
    )
    parser.add_argument("segments_csv", help="Path to segments.csv from analyze_distribution")
    parser.add_argument(
        "--inner-iters",
        type=int,
        default=100,
        help="INNER_ITERS used during measurement (default: 100)",
    )
    parser.add_argument(
        "--textual-rept",
        type=int,
        default=100,
        help="TEXTUAL_REPT used during measurement (default: 100)",
    )
    args = parser.parse_args()

    compute_parameters(args.segments_csv, args.inner_iters, args.textual_rept)


if __name__ == "__main__":
    main()
