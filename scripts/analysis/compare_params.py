#!/usr/bin/env python3
import argparse
import json
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np


def load_parameter_dict(path: Path) -> tuple[str | None, dict[str, float]]:
    with open(path, "r") as f:
        data = json.load(f)

    parameters = data.get("parameters")
    if not isinstance(parameters, dict):
        raise ValueError(f"{path} does not contain a top-level 'parameters' dict")

    return data.get("model"), {str(k): float(v) for k, v in parameters.items()}


def align_parameters(
    params_a: dict[str, float], params_b: dict[str, float]
) -> tuple[list[str], np.ndarray, np.ndarray]:
    common_keys = sorted(set(params_a) & set(params_b))
    if not common_keys:
        raise ValueError("No common parameter keys between the two JSON files.")

    values_a = np.array([params_a[key] for key in common_keys], dtype=float)
    values_b = np.array([params_b[key] for key in common_keys], dtype=float)
    return common_keys, values_a, values_b


def print_summary(
    label_a: str,
    label_b: str,
    keys: list[str],
    values_a: np.ndarray,
    values_b: np.ndarray,
    top_k: int,
):
    delta = values_b - values_a
    ratio = np.divide(values_b, values_a, out=np.full_like(values_b, np.nan), where=values_a != 0)
    abs_delta = np.abs(delta)

    print(f"Compared keys: {len(keys)}")
    print(f"Mean({label_a}): {values_a.mean():.6f}")
    print(f"Mean({label_b}): {values_b.mean():.6f}")
    print(f"Mean delta ({label_b} - {label_a}): {delta.mean():.6f}")
    print(f"Median abs delta: {np.median(abs_delta):.6f}")
    print(f"Max abs delta: {abs_delta.max():.6f}")

    corr = np.corrcoef(values_a, values_b)[0, 1] if len(keys) > 1 else float("nan")
    print(f"Pearson correlation: {corr:.6f}")

    top_indices = np.argsort(abs_delta)[-top_k:][::-1]
    print(f"\nTop {len(top_indices)} changed keys:")
    for idx in top_indices:
        ratio_str = "nan" if np.isnan(ratio[idx]) else f"{ratio[idx]:.3f}x"
        print(
            f"  {keys[idx]}: {label_a}={values_a[idx]:.6f}, "
            f"{label_b}={values_b[idx]:.6f}, delta={delta[idx]:+.6f}, ratio={ratio_str}"
        )


def plot_comparison(
    label_a: str,
    label_b: str,
    keys: list[str],
    values_a: np.ndarray,
    values_b: np.ndarray,
    top_k: int,
    title: str | None,
    output: Path | None,
):
    delta = values_b - values_a
    abs_delta = np.abs(delta)
    top_indices = np.argsort(abs_delta)[-top_k:][::-1]

    fig, (ax_scatter, ax_bar) = plt.subplots(
        1, 2, figsize=(14, 6), gridspec_kw={"width_ratios": [1.2, 1.0]}
    )

    ax_scatter.scatter(values_a, values_b, alpha=0.75, color="steelblue", edgecolors="none")

    diag_min = min(values_a.min(), values_b.min())
    diag_max = max(values_a.max(), values_b.max())
    ax_scatter.plot(
        [diag_min, diag_max],
        [diag_min, diag_max],
        linestyle="--",
        color="black",
        linewidth=1,
        label="y = x",
    )

    for idx in top_indices:
        ax_scatter.scatter(values_a[idx], values_b[idx], color="darkorange", s=50, zorder=3)
        ax_scatter.annotate(
            keys[idx],
            (values_a[idx], values_b[idx]),
            textcoords="offset points",
            xytext=(5, 5),
            fontsize=8,
        )

    ax_scatter.set_xlabel(label_a)
    ax_scatter.set_ylabel(label_b)
    ax_scatter.set_title("Parameter Parity")
    ax_scatter.grid(True, alpha=0.3, linestyle="--")
    ax_scatter.legend(loc="upper left")

    top_keys = [keys[idx] for idx in top_indices][::-1]
    top_delta = delta[top_indices][::-1]
    colors = ["seagreen" if value >= 0 else "firebrick" for value in top_delta]
    ax_bar.barh(top_keys, top_delta, color=colors, alpha=0.85)
    ax_bar.axvline(0, color="black", linewidth=1)
    ax_bar.set_xlabel(f"{label_b} - {label_a}")
    ax_bar.set_title(f"Top {len(top_keys)} Absolute Changes")
    ax_bar.grid(True, axis="x", alpha=0.3, linestyle="--")

    fig.suptitle(title or f"{label_a} vs {label_b}", fontsize=14, fontweight="bold")
    plt.tight_layout()

    if output is not None:
        output.parent.mkdir(parents=True, exist_ok=True)
        plt.savefig(output, dpi=300, bbox_inches="tight")
        print(f"\nSaved plot to {output}")
    else:
        plt.show()


def main():
    parser = argparse.ArgumentParser(
        description=(
            "Compare two parameter JSON files visually with a parity plot and "
            "top-changes bar chart."
        )
    )
    parser.add_argument("json_a", type=Path, help="First parameter JSON file")
    parser.add_argument("json_b", type=Path, help="Second parameter JSON file")
    parser.add_argument(
        "--label-a",
        type=str,
        default=None,
        help="Legend label for the first file (default: filename stem)",
    )
    parser.add_argument(
        "--label-b",
        type=str,
        default=None,
        help="Legend label for the second file (default: filename stem)",
    )
    parser.add_argument(
        "--top-k",
        type=int,
        default=20,
        help="Number of largest absolute parameter changes to highlight (default: 20)",
    )
    parser.add_argument(
        "--title",
        type=str,
        default=None,
        help="Optional figure title",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="Optional output image path (e.g. report/params_compare.png)",
    )
    args = parser.parse_args()

    model_a, params_a = load_parameter_dict(args.json_a)
    model_b, params_b = load_parameter_dict(args.json_b)

    if model_a != model_b:
        print(f"Warning: model mismatch: {model_a!r} vs {model_b!r}")

    keys, values_a, values_b = align_parameters(params_a, params_b)
    label_a = args.label_a or args.json_a.stem
    label_b = args.label_b or args.json_b.stem

    only_a = sorted(set(params_a) - set(params_b))
    only_b = sorted(set(params_b) - set(params_a))
    if only_a:
        print(f"Keys only in {args.json_a.name} (ignored): {len(only_a)}")
    if only_b:
        print(f"Keys only in {args.json_b.name} (ignored): {len(only_b)}")

    print_summary(label_a, label_b, keys, values_a, values_b, args.top_k)
    plot_comparison(
        label_a, label_b, keys, values_a, values_b, args.top_k, args.title, args.output
    )


if __name__ == "__main__":
    main()
