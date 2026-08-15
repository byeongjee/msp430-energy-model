#!/usr/bin/env python3
import argparse
import json
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np

# -----------------------------------------------------------------------------
# A scatter plot between two boards shows whether key *ratios*
# are preserved. If points lie close to a straight line, the boards differ
# mostly by a global scale factor; deviations from the line reveal modes whose
# relative costs drift across hardware.
# -----------------------------------------------------------------------------


def load_parameters(path: Path):
    with open(path, "r") as f:
        data = json.load(f)
    if "parameters" not in data or not isinstance(data["parameters"], dict):
        raise ValueError(f"{path} does not contain a 'parameters' dict at top level")
    return data["parameters"]


def main():
    parser = argparse.ArgumentParser(
        description="Scatter-plot comparison of key costs between two boards"
    )
    parser.add_argument("json_a", type=Path, help="First JSON file (Board A)")
    parser.add_argument("json_b", type=Path, help="Second JSON file (Board B)")
    parser.add_argument(
        "--title",
        type=str,
        default=None,
        help="Optional plot title (default: 'Board A vs Board B')",
    )
    parser.add_argument(
        "--show-labels",
        action="store_true",
        help="Annotate outlier points with key names",
    )
    parser.add_argument(
        "--outlier-sigma",
        type=float,
        default=1.0,
        help="Residual standard deviations used to mark outliers (default: 1.0)",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="Optional output file path to save the plot (e.g., scatter.png)",
    )

    args = parser.parse_args()

    params_a = load_parameters(args.json_a)
    params_b = load_parameters(args.json_b)

    keys_a = set(params_a.keys())
    keys_b = set(params_b.keys())
    common_keys = sorted(keys_a & keys_b)

    if not common_keys:
        raise SystemExit("No common parameter keys between the two JSON files.")

    dropped_a = keys_a - keys_b
    dropped_b = keys_b - keys_a
    if dropped_a:
        print(f"Keys only in {args.json_a.name} (ignored): {len(dropped_a)}")
    if dropped_b:
        print(f"Keys only in {args.json_b.name} (ignored): {len(dropped_b)}")

    # Build aligned vectors
    x = np.array([params_a[k] for k in common_keys])
    y = np.array([params_b[k] for k in common_keys])

    # Fit a line y = m x + b
    m, b = np.polyfit(x, y, 1)
    y_hat = m * x + b
    residuals = y - y_hat
    sigma = np.std(residuals) if len(residuals) > 1 else 0.0

    # R^2 for curiosity
    ss_res = np.sum(residuals**2)
    ss_tot = np.sum((y - np.mean(y)) ** 2)
    r2 = 1.0 - ss_res / ss_tot if ss_tot > 0 else float("nan")

    if sigma > 0:
        outlier_mask = np.abs(residuals) > (args.outlier_sigma * sigma)
    else:
        outlier_mask = np.zeros_like(residuals, dtype=bool)

    inlier_mask = ~outlier_mask

    print(f"Fitted line: y = {m:.6f} x + {b:.6f}")
    print(f"Residual std (sigma): {sigma:.6f}")
    print(f"R^2: {r2:.6f}")
    print(f"Outlier threshold: {args.outlier_sigma} * sigma")

    common_keys_arr = np.array(common_keys)

    # Print outliers and how much they deviate
    if np.any(outlier_mask):
        print("\nOutliers:")
        # sort outliers by absolute residual descending
        out_idx = np.where(outlier_mask)[0]
        out_idx = out_idx[np.argsort(np.abs(residuals[out_idx]))[::-1]]
        for i in out_idx:
            key = common_keys_arr[i]
            xi = x[i]
            yi = y[i]
            y_pred = y_hat[i]
            res = residuals[i]
            rel_err = res / y_pred if y_pred != 0 else float("inf")
            ratio = yi / xi if xi != 0 else float("inf")
            print(
                f"---{key}---\n A={xi:.6f}\tB={yi:.6f}\t, "
                f"pred(B)={y_pred:.6f}\tresid={res:.6f}\t"
                f"rel_resid={rel_err:.3%}\tB/A={ratio:.3f}\t"
            )
    else:
        print("\nNo outliers above the chosen sigma threshold.")

    # Plot (larger figure for readability)
    plt.figure(figsize=(10, 10))
    plt.scatter(
        x[inlier_mask],
        y[inlier_mask],
        label="keys (inliers)",
        alpha=0.7,
    )
    if np.any(outlier_mask):
        plt.scatter(
            x[outlier_mask],
            y[outlier_mask],
            label=f"Outliers (> {args.outlier_sigma}σ)",
            marker="x",
            s=80,
        )

    # Best-fit line
    x_line = np.linspace(x.min(), x.max(), 200)
    plt.plot(
        x_line,
        m * x_line + b,
        linestyle="--",
        label=f"Fit: y = {m:.3f}x + {b:.3f}",
    )

    # Reference diagonal
    diag_min = min(x.min(), y.min())
    diag_max = max(x.max(), y.max())
    plt.plot(
        [diag_min, diag_max],
        [diag_min, diag_max],
        linestyle=":",
        label="y = x (perfect match)",
    )

    plt.xlabel(f"{args.json_a.name} key")
    plt.ylabel(f"{args.json_b.name} key")
    title = args.title or f"{args.json_a.name} vs {args.json_b.name}"
    plt.title(title)
    plt.grid(True)
    plt.legend()

    # Optional labels on outlier points
    if args.show_labels and np.any(outlier_mask):
        for key, xi, yi in zip(
            common_keys_arr[outlier_mask], x[outlier_mask], y[outlier_mask]
        ):
            plt.annotate(
                key,
                (xi, yi),
                textcoords="offset points",
                xytext=(5, 5),
                fontsize=8,
            )

    plt.tight_layout()

    if args.output:
        plt.savefig(args.output, dpi=300, bbox_inches="tight")
        print(f"Plot saved to {args.output}")
    else:
        plt.show()


if __name__ == "__main__":
    main()
