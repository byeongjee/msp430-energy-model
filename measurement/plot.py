#!/usr/bin/env python3
import argparse, csv, math, os, sys
from typing import Tuple
import numpy as np
import matplotlib.pyplot as plt


# ---------- streaming window finder ----------
def find_window_first(csv_path: str, gpi1_col="gpi1") -> Tuple[int, int, int]:
    """
    Find FIRST gpi1 window: first 0->1 to subsequent 1->0.
    Returns (rise_idx, start_idx, end_idx).
    """
    rise_idx = None
    start_idx = None
    prev = None
    idx = -1
    with open(csv_path, "r", newline="") as f:
        r = csv.DictReader(f)
        if gpi1_col not in r.fieldnames:
            raise ValueError(f"'{gpi1_col}' not in CSV header {r.fieldnames}")
        for row in r:
            idx += 1
            try:
                v = int(row[gpi1_col])
            except Exception:
                v = 0
            if prev is None:
                prev = v
                continue
            if start_idx is None and prev == 0 and v == 1:
                rise_idx = idx
                start_idx = idx
            elif start_idx is not None and prev == 1 and v == 0:
                return rise_idx, start_idx, idx
            prev = v
    if start_idx is not None:
        return rise_idx, start_idx, idx
    raise RuntimeError("No gpi1 0→1→0 window found.")


# ---------- efficient loading of a slice ----------
def load_slice(csv_path: str, i_start: int, i_end: int):
    cols = ("timestamp_s", "current_A", "power_W", "gpi1", "gpi2")
    ts, ia, pw, g1, e2 = [], [], [], [], []
    with open(csv_path, "r", newline="") as f:
        r = csv.DictReader(f)
        for c in cols:
            if c not in r.fieldnames:
                raise ValueError(f"Missing column '{c}' in CSV.")
        idx = -1
        for row in r:
            idx += 1
            if idx < i_start:
                continue
            if idx > i_end:
                break
            ts.append(float(row["timestamp_s"]))
            ia.append(float(row["current_A"]))
            pw.append(float(row["power_W"]))
            try:
                g1.append(int(row["gpi1"]))
            except Exception:
                g1.append(0)
            e2.append(row["gpi2"].strip())  # "", "1", "0"
    return (
        np.asarray(ts),
        np.asarray(ia),
        np.asarray(pw),
        np.asarray(g1, dtype=int),
        np.array(e2, dtype=object),
    )


# ---------- build gpi2 waveform (connected) ----------
def gpi2_from_events(e2_sparse: np.ndarray) -> np.ndarray:
    state = 0
    out = np.empty(len(e2_sparse), dtype=int)
    for i, v in enumerate(e2_sparse):
        if v == "1":
            state = 1
        elif v == "0":
            state = 0
        out[i] = state
    return out


# ---------- downsampling ----------
def downsample_envelope(x: np.ndarray, y: np.ndarray, max_points: int):
    n = len(x)
    if n <= max_points:
        return x, y
    buckets = max_points
    size = n // buckets
    if size < 2:
        step = int(math.ceil(n / max_points))
        return x[::step], y[::step]
    xs, ys = [], []
    for i in range(buckets):
        s = i * size
        e = n if i == buckets - 1 else (i + 1) * size
        xb, yb = x[s:e], y[s:e]
        if len(xb) == 0:
            continue
        jmin, jmax = int(np.argmin(yb)), int(np.argmax(yb))
        if jmin <= jmax:
            xs.extend([xb[jmin], xb[jmax]])
            ys.extend([yb[jmin], yb[jmax]])
        else:
            xs.extend([xb[jmax], xb[jmin]])
            ys.extend([yb[jmax], yb[jmin]])
    return np.asarray(xs), np.asarray(ys)


def compress_step(x, y):
    """Return (xc, yc) so drawstyle='steps-post' is efficient."""
    if len(y) == 0:
        return x, y
    change = np.r_[True, np.diff(y) != 0]
    xc = x[change]
    yc = y[change]
    if xc[-1] != x[-1]:
        xc = np.r_[xc, x[-1]]
        yc = np.r_[yc, yc[-1]]
    return xc, yc


def main():
    ap = argparse.ArgumentParser(
        description="Validate & visualize run.csv around gpi1=1 window."
    )
    ap.add_argument("csv", nargs="?", default="run.csv")
    ap.add_argument(
        "--max-points",
        type=int,
        default=20000,
        help="Max plotted points (per analog series)",
    )
    ap.add_argument(
        "--pre-context",
        type=float,
        default=0.0005,
        help="Seconds BEFORE GPI1 rising edge",
    )
    ap.add_argument(
        "--post-context",
        type=float,
        default=0.0005,
        help="Seconds AFTER GPI1 falling edge",
    )
    args = ap.parse_args()

    if not os.path.isfile(args.csv):
        print(f"File not found: {args.csv}", file=sys.stderr)
        sys.exit(1)

    # 1) Find window and rise index
    rise_idx, i_start, i_end = find_window_first(args.csv, "gpi1")

    # 2) Load all timestamps once to compute local dt and apply pre/post margins
    ts_all, ia_all, pw_all, g1_all, e2_all = load_slice(args.csv, 0, 10**12)
    if len(ts_all) < 2:
        print("Not enough samples.", file=sys.stderr)
        sys.exit(1)

    # robust local dt around rise/fall
    def local_dt_around(idx):
        a = max(1, idx - 5)
        b = min(len(ts_all) - 1, idx + 5)
        return float(np.median(np.diff(ts_all[a - 1 : b + 1])))

    dt_rise = local_dt_around(rise_idx)
    dt_fall = local_dt_around(i_end)

    pre_extra = int(round(args.pre_context / max(dt_rise, 1e-15)))
    post_extra = int(round(args.post_context / max(dt_fall, 1e-15)))

    i_start2 = max(0, i_start - pre_extra)
    i_end2 = min(len(ts_all) - 1, i_end + post_extra)

    # 3) Slice arrays to final window+context
    ts = ts_all[i_start2 : i_end2 + 1]
    ia = ia_all[i_start2 : i_end2 + 1]
    pw = pw_all[i_start2 : i_end2 + 1]
    g1 = g1_all[i_start2 : i_end2 + 1]
    e2 = e2_all[i_start2 : i_end2 + 1]

    # 4) Reconstruct gpi2 waveform (connected)
    g2 = gpi2_from_events(e2)

    # 5) Downsample analogs
    xs_i, ys_i = downsample_envelope(ts, ia, args.max_points)
    xs_p, ys_p = downsample_envelope(ts, pw, args.max_points)

    # 6) Compress digitals
    xg1, yg1 = compress_step(ts, g1.astype(float))
    xg2, yg2 = compress_step(ts, g2.astype(float))

    # 7) Plot: current & power; gpi1 near bottom; gpi2 below gpi1
    fig, ax1 = plt.subplots(figsize=(10, 5))
    ax1.plot(xs_i, ys_i, linewidth=0.9, label="current_A")
    ax1.set_xlabel("time (s)")
    ax1.set_ylabel("current (A)")
    ax2 = ax1.twinx()
    ax2.plot(xs_p, ys_p, linewidth=0.9, linestyle="--", label="power_W")
    ax2.set_ylabel("power (W)")

    y1min, y1max = float(np.min(ys_i)), float(np.max(ys_i))
    span = y1max - y1min if y1max > y1min else (abs(y1max) + 1e-12)

    g1_base = y1min - 0.12 * span
    g1_amp = 0.07 * span
    g2_base = y1min - 0.24 * span  # lower than gpi1
    g2_amp = 0.07 * span

    ax1.plot(
        xg1,
        yg1 * g1_amp + g1_base,
        drawstyle="steps-post",
        linewidth=0.9,
        label="gpi1 (scaled)",
    )
    ax1.plot(
        xg2,
        yg2 * g2_amp + g2_base,
        drawstyle="steps-post",
        linewidth=0.9,
        label="gpi2 (scaled)",
    )

    # ensure the lower overlays are visible
    ax1.set_ylim(bottom=min(g2_base - 0.05 * span, y1min - 0.3 * span))

    ax1.grid(True, linewidth=0.3, alpha=0.5)
    ax1.legend(loc="upper left", fontsize=8, frameon=False)
    ax2.legend(loc="upper right", fontsize=8, frameon=False)
    fig.tight_layout()
    plt.savefig("plot.png")
    plt.show()


if __name__ == "__main__":
    main()
