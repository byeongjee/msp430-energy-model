#!/usr/bin/env python3
"""
Analyze least-squares training debug dump to identify issues with energy model training.

Usage:
    python scripts/analyze_least_squares.py experiments/activity_recognition_mem_access_debug/ls_debug.json
"""

import json
import sys
import numpy as np
from collections import defaultdict

def load_debug_data(filepath):
    """Load the debug dump JSON file."""
    with open(filepath, 'r') as f:
        return json.load(f)

def reconstruct_matrix_A(data):
    """Reconstruct the full A matrix from sparse representation."""
    shape = data['matrix_A_shape']
    A = np.zeros((int(shape[0]), int(shape[1])))
    for entry in data['matrix_A_sparse']:
        row, col, val = entry
        A[int(row)-1, int(col)-1] = val  # Convert from 1-indexed to 0-indexed
    return A

def analyze_rank_deficiency(A, key_labels, singular_values):
    """Analyze which columns contribute to rank deficiency."""
    print("\n" + "="*60)
    print("RANK DEFICIENCY ANALYSIS")
    print("="*60)

    n_samples, n_keys = A.shape
    rank = np.linalg.matrix_rank(A)

    print(f"Matrix shape: {n_samples} samples × {n_keys} keys")
    print(f"Matrix rank: {rank}")
    print(f"Rank deficiency: {n_keys - rank} (need {n_keys - rank} more independent samples)")

    # SVD analysis
    U, S, Vt = np.linalg.svd(A, full_matrices=False)

    print(f"\nSingular values (smallest 10):")
    for i, sv in enumerate(sorted(S)[:10]):
        print(f"  σ_{len(S)-i}: {sv:.6e}")

    # Find near-zero singular values (these indicate dependent columns)
    threshold = 1e-10
    near_zero_indices = np.where(S < threshold)[0]

    if len(near_zero_indices) > 0:
        print(f"\n{len(near_zero_indices)} singular values near zero (< {threshold})")

        # The corresponding right singular vectors show the linear dependencies
        print("\nLinear dependencies found in columns:")
        for idx in near_zero_indices:
            v = Vt[idx, :]
            # Find columns with significant contribution to this null-space vector
            significant = np.where(np.abs(v) > 0.1)[0]
            if len(significant) > 0:
                print(f"\n  Dependency group (singular value {S[idx]:.2e}):")
                for col in significant:
                    print(f"    - {key_labels[col]} (coef: {v[col]:.4f})")

def analyze_column_coverage(A, key_labels, column_coverage):
    """Analyze how well each key is covered by training data."""
    print("\n" + "="*60)
    print("COLUMN COVERAGE ANALYSIS")
    print("="*60)

    # Sort by coverage
    coverage_with_labels = list(zip(key_labels, column_coverage))
    coverage_with_labels.sort(key=lambda x: x[1])

    print("\nKeys with lowest coverage (fewest training samples):")
    for label, cov in coverage_with_labels[:15]:
        print(f"  {label}: {cov} samples")

    # Find keys that appear in very few samples
    low_coverage_threshold = 5
    low_coverage_keys = [(l, c) for l, c in coverage_with_labels if c <= low_coverage_threshold]

    if low_coverage_keys:
        print(f"\n⚠️  {len(low_coverage_keys)} keys have coverage ≤ {low_coverage_threshold}:")
        for label, cov in low_coverage_keys:
            print(f"    {label}: {cov}")

def analyze_residuals(data, key_labels):
    """Analyze training residuals to find poorly-fit samples."""
    print("\n" + "="*60)
    print("RESIDUAL ANALYSIS")
    print("="*60)

    residuals = np.array(data['residuals'])
    relative_errors = np.array(data['relative_errors_percent'])
    measured_B = np.array(data['measured_B'])
    predicted_B = np.array(data['predicted_B'])

    print(f"\nResidual statistics:")
    print(f"  Mean residual: {np.mean(residuals):.2f} nJ")
    print(f"  Std residual: {np.std(residuals):.2f} nJ")
    print(f"  Max abs residual: {np.max(np.abs(residuals)):.2f} nJ")

    print(f"\nRelative error statistics:")
    print(f"  Mean relative error: {np.mean(np.abs(relative_errors)):.2f}%")
    print(f"  Max relative error: {np.max(np.abs(relative_errors)):.2f}%")

    # Find samples with largest residuals
    worst_indices = np.argsort(np.abs(residuals))[-10:][::-1]

    print(f"\nTop 10 samples with largest residuals:")
    print(f"  {'Sample':<8} {'Measured':>12} {'Predicted':>12} {'Residual':>12} {'Error%':>10}")
    print(f"  {'-'*8} {'-'*12} {'-'*12} {'-'*12} {'-'*10}")
    for idx in worst_indices:
        print(f"  {idx:<8} {measured_B[idx]:>12.2f} {predicted_B[idx]:>12.2f} {residuals[idx]:>12.2f} {relative_errors[idx]:>10.2f}%")

    # Determine which file each sample came from based on the known structure
    # From output: 200 + 200 + 200 + 100 + 1 + 30 = 731
    sample_files = []
    file_boundaries = [
        (0, 200, "batch_0000"),
        (200, 400, "batch_0001"),
        (400, 600, "batch_0002"),
        (600, 700, "batch_0003"),
        (700, 701, "br_immediate"),
        (701, 731, "fram_cache_benchmark"),
    ]

    for idx in range(len(residuals)):
        for start, end, name in file_boundaries:
            if start <= idx < end:
                sample_files.append(name)
                break

    # Aggregate residuals by file
    print(f"\nResiduals by training file:")
    file_residuals = defaultdict(list)
    for idx, res in enumerate(residuals):
        file_residuals[sample_files[idx]].append(res)

    for name, res_list in file_residuals.items():
        mean_res = np.mean(res_list)
        std_res = np.std(res_list)
        max_res = np.max(np.abs(res_list))
        print(f"  {name}: mean={mean_res:.2f}, std={std_res:.2f}, max_abs={max_res:.2f}")

def analyze_solution(data, key_labels):
    """Analyze the learned solution parameters."""
    print("\n" + "="*60)
    print("SOLUTION ANALYSIS")
    print("="*60)

    x = np.array(data['solution_x'])

    print(f"\nLearned parameter statistics:")
    print(f"  Min: {np.min(x):.4f} nJ")
    print(f"  Max: {np.max(x):.4f} nJ")
    print(f"  Mean: {np.mean(x):.4f} nJ")
    print(f"  Std: {np.std(x):.4f} nJ")

    # Find negative parameters (shouldn't happen for energy!)
    negative_params = [(key_labels[i], x[i]) for i in range(len(x)) if x[i] < 0]
    if negative_params:
        print(f"\n⚠️  {len(negative_params)} NEGATIVE parameters found (physically impossible for energy):")
        for label, val in sorted(negative_params, key=lambda x: x[1]):
            print(f"    {label}: {val:.4f} nJ")

    # Find unusually large parameters
    threshold = np.mean(x) + 3 * np.std(x)
    large_params = [(key_labels[i], x[i]) for i in range(len(x)) if x[i] > threshold]
    if large_params:
        print(f"\n⚠️  {len(large_params)} unusually large parameters (> 3σ from mean):")
        for label, val in sorted(large_params, key=lambda x: -x[1]):
            print(f"    {label}: {val:.4f} nJ")

    # Sort by value
    sorted_params = sorted(zip(key_labels, x), key=lambda x: x[1])

    print(f"\nSmallest 10 parameters:")
    for label, val in sorted_params[:10]:
        print(f"  {label}: {val:.4f} nJ")

    print(f"\nLargest 10 parameters:")
    for label, val in sorted_params[-10:][::-1]:
        print(f"  {label}: {val:.4f} nJ")

def analyze_collinearity(A, key_labels):
    """Find pairs/groups of columns that are highly correlated."""
    print("\n" + "="*60)
    print("COLLINEARITY ANALYSIS")
    print("="*60)

    n_keys = A.shape[1]

    # Compute correlation matrix
    # Normalize columns first
    A_norm = A - A.mean(axis=0)
    norms = np.linalg.norm(A_norm, axis=0)
    norms[norms == 0] = 1  # Avoid division by zero
    A_norm = A_norm / norms

    corr = A_norm.T @ A_norm / A.shape[0]

    # Find highly correlated pairs
    high_corr_pairs = []
    for i in range(n_keys):
        for j in range(i+1, n_keys):
            if abs(corr[i, j]) > 0.9:
                high_corr_pairs.append((key_labels[i], key_labels[j], corr[i, j]))

    if high_corr_pairs:
        print(f"\n⚠️  {len(high_corr_pairs)} highly correlated column pairs (|r| > 0.9):")
        for k1, k2, r in sorted(high_corr_pairs, key=lambda x: -abs(x[2])):
            print(f"  {k1} ↔ {k2}: r={r:.4f}")
    else:
        print("\nNo highly correlated column pairs found.")

def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <debug_dump.json>")
        sys.exit(1)

    filepath = sys.argv[1]
    print(f"Loading debug dump from: {filepath}")

    data = load_debug_data(filepath)

    # Print metadata
    print("\n" + "="*60)
    print("METADATA")
    print("="*60)
    for k, v in data['metadata'].items():
        if isinstance(v, float):
            print(f"  {k}: {v:.6g}")
        else:
            print(f"  {k}: {v}")

    key_labels = data['key_labels']
    A = reconstruct_matrix_A(data)

    # Run analyses
    analyze_rank_deficiency(A, key_labels, data['singular_values'])
    analyze_column_coverage(A, key_labels, data['column_coverage'])
    analyze_collinearity(A, key_labels)
    analyze_solution(data, key_labels)
    analyze_residuals(data, key_labels)

    print("\n" + "="*60)
    print("ANALYSIS COMPLETE")
    print("="*60)

if __name__ == "__main__":
    main()
