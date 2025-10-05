#!/usr/bin/env python3
"""
preprocess.py

Compute energy per segment from a CSV produced by measure.py.

Definitions:
- Measurement interval: contiguous samples where GPI1 == 1
- Segment: contiguous samples (within a measurement interval) where GPI2 == 1

Assumptions:
- GPI2 starts LOW. If the first GPI2 event is a FALL ('0') before any RISE ('1'),
  emit a warning and ignore that fall.
"""

import argparse, csv, sys
from typing import Optional, List
from scipy.integrate import trapezoid as trapz  # trapz(y, x)


def parse_args():
    ap = argparse.ArgumentParser(
        description="Compute per-segment energy (GPI2==1 within GPI1==1)."
    )
    ap.add_argument("csv_in", help="Input CSV from measure.py")
    ap.add_argument("--out", default="segments.csv", help="Output CSV path")
    ap.add_argument(
        "--min-duration",
        type=float,
        default=0.0,
        help="Drop segments shorter than this (s)",
    )
    return ap.parse_args()


def f_int(s: str, default=0) -> int:
    try:
        return int(s)
    except:
        return default


def f_float(s: str, default=0.0) -> float:
    try:
        return float(s)
    except:
        return default


def main():
    args = parse_args()

    # Measurement / segment state
    meas_idx = -1  # increments on GPI1 0->1; becomes 0 if file starts high
    seg_idx = -1  # resets at each new measurement interval
    in_meas = False  # gpi1 == 1

    # GPI2 reconstruction (starts LOW by assumption)
    gpi2_level = 0
    seen_gpi2_rise = False
    warned_initial_fall = False

    # Active segment buffers
    seg_t0: Optional[float] = None
    seg_ts: List[float] = []
    seg_pw: List[float] = []
    seg_ia: List[float] = []

    wrote = 0
    prev_g1: Optional[int] = None

    with (
        open(args.csv_in, "r", newline="") as fin,
        open(args.out, "w", newline="") as fout,
    ):
        r = csv.DictReader(fin)
        for col in ("timestamp_s", "current_A", "power_W", "gpi1", "gpi2"):
            if col not in r.fieldnames:
                raise ValueError(
                    f"Missing column '{col}' in input CSV. Found: {r.fieldnames}"
                )

        w = csv.writer(fout)
        w.writerow(
            [
                "meas_interval_idx",
                "segment_idx",
                "t_start_s",
                "t_end_s",
                "duration_s",
                "energy_J",
                "avg_power_W",
                "avg_current_A",
                "charge_C",
            ]
        )

        for row in r:
            ts = f_float(row["timestamp_s"])
            ia = f_float(row["current_A"])
            pw = f_float(row["power_W"])
            g1 = f_int(row["gpi1"])

            # Update GPI2 level from sparse events (start LOW; ignore initial FALL)
            ev = (row["gpi2"] or "").strip()
            if ev == "1":
                gpi2_level = 1
                seen_gpi2_rise = True
            elif ev == "0":
                if not seen_gpi2_rise:
                    if not warned_initial_fall:
                        print(
                            "[preprocess] Warning: first GPI2 event is a FALL ('0') before any RISE; "
                            "assuming initial LOW and ignoring this fall.",
                            file=sys.stderr,
                        )
                        warned_initial_fall = True
                    # ignore
                else:
                    gpi2_level = 0

            # Initialize on first row
            if prev_g1 is None:
                prev_g1 = g1
                if g1 == 1:
                    meas_idx += 1
                    in_meas = True
                    if gpi2_level == 1:
                        seg_idx += 1
                        seg_t0 = ts
                        seg_ts = [ts]
                        seg_pw = [pw]
                        seg_ia = [ia]
                continue

            # Update measurement interval (GPI1 edges)
            if prev_g1 == 0 and g1 == 1:
                meas_idx += 1
                in_meas = True
                seg_idx = -1  # reset per new measurement interval
            elif prev_g1 == 1 and g1 == 0:
                in_meas = False

            # Determine segment activity using UPDATED in_meas / gpi2_level
            active_prev = seg_t0 is not None
            active_now = in_meas and gpi2_level == 1

            # START: not active -> active
            if (not active_prev) and active_now:
                seg_idx += 1
                seg_t0 = ts
                seg_ts = [ts]
                seg_pw = [pw]
                seg_ia = [ia]

            # CONTINUE: active previously -> always append current sample first
            elif active_prev:
                seg_ts.append(ts)
                seg_pw.append(pw)
                seg_ia.append(ia)

                # END: became inactive at this sample -> close using buffers that include 'ts'
                if not active_now:
                    if len(seg_ts) >= 2:
                        duration = seg_ts[-1] - seg_t0
                        if duration >= args.min_duration:
                            energy = float(trapz(seg_pw, seg_ts))
                            charge = float(trapz(seg_ia, seg_ts))
                            avg_p = energy / duration if duration > 0 else 0.0
                            avg_i = charge / duration if duration > 0 else 0.0
                            w.writerow(
                                [
                                    meas_idx,
                                    seg_idx,
                                    f"{seg_t0:.9f}",
                                    f"{seg_ts[-1]:.9f}",
                                    f"{duration:.9f}",
                                    f"{energy:.12g}",
                                    f"{avg_p:.12g}",
                                    f"{avg_i:.12g}",
                                    f"{charge:.12g}",
                                ]
                            )
                            wrote += 1
                    # reset buffers
                    seg_t0 = None
                    seg_ts.clear()
                    seg_pw.clear()
                    seg_ia.clear()

            prev_g1 = g1

        # EOF: if still active, close using last appended sample
        if seg_t0 is not None and len(seg_ts) >= 2:
            duration = seg_ts[-1] - seg_t0
            if duration >= args.min_duration:
                energy = float(trapz(seg_pw, seg_ts))
                charge = float(trapz(seg_ia, seg_ts))
                avg_p = energy / duration if duration > 0 else 0.0
                avg_i = charge / duration if duration > 0 else 0.0
                w.writerow(
                    [
                        meas_idx,
                        seg_idx,
                        f"{seg_t0:.9f}",
                        f"{seg_ts[-1]:.9f}",
                        f"{duration:.9f}",
                        f"{energy:.12g}",
                        f"{avg_p:.12g}",
                        f"{avg_i:.12g}",
                        f"{charge:.12g}",
                    ]
                )
                wrote += 1

    print(f"Wrote {wrote} segment(s) to {args.out}")


if __name__ == "__main__":
    main()
