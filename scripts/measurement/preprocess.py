#!/usr/bin/env python3
import pandas as pd
from scipy import integrate
import argparse
import json


def preprocess_csv(input, output, event_labels=None):
    """
    Preprocess CSV file to extract segments where GPI2=1 and calculate energy.
    Parameters:
    input_file: Path to input CSV file
    output_file: Path to output CSV file
    event_labels: Optional list of event labels (function names from BENCH() macros)
    """
    # Read the CSV file
    df = pd.read_csv(input)
    # Forward fill the GPI2 column to handle empty values
    df["gpi2"] = df["gpi2"].ffill()
    # Fill any remaining NaN values at the start with 0
    df["gpi2"] = df["gpi2"].fillna(0)
    # convert gpi2 to int
    df["gpi2"] = df["gpi2"].astype(int)
    # Truncate rows where GPI1 = 0
    df = df[df["gpi1"] == 1].reset_index(drop=True)
    # Now identify segments where GPI2 = 1
    # Since we've forward-filled, we can now detect actual changes
    df["gpi2_shifted"] = df["gpi2"].shift(1, fill_value=0)
    df["segment_start"] = (df["gpi2"] == 1) & (df["gpi2_shifted"] != 1)
    df["segment_id"] = df["segment_start"].cumsum()
    # Filter only rows where GPI2 = 1 and assign them to segments
    gpi2_segments = df[df["gpi2"] == 1].copy()
    # Group by segment_id and calculate statistics
    results = []
    for _segment_id, group in gpi2_segments.groupby("segment_id"):
        t_start_s = group["timestamp_s"].iloc[0]
        t_end_s = group["timestamp_s"].iloc[-1]
        duration_s = t_end_s - t_start_s
        # Calculate energy using trapezoidal integration
        timestamps = group["timestamp_s"].values
        power = group["power_W"].values
        energy_J = integrate.trapezoid(power, timestamps)
        # Convert to nanoJoules for better numerical stability
        energy_nJ = energy_J * 1e9
        results.append(
            {
                "t_start_s": t_start_s,
                "t_end_s": t_end_s,
                "duration_s": duration_s,
                "energy_nJ": energy_nJ,
            }
        )
    # Create output DataFrame
    output_df = pd.DataFrame(results)

    # Drop spurious zero-length zero-energy segments caused by GPIO boundary artifacts.
    if not output_df.empty:
        degenerate_mask = (
            output_df["duration_s"].abs().eq(0) & output_df["energy_nJ"].abs().eq(0)
        )
        dropped_count = int(degenerate_mask.sum())
        if dropped_count:
            output_df = output_df.loc[~degenerate_mask].reset_index(drop=True)
            print(
                f"Dropped {dropped_count} degenerate zero-length zero-energy segment(s)"
            )

    # Add event labels if provided
    if event_labels is not None and len(event_labels) > 0:
        # Assign event labels to segments
        # Each event should have the same number of segments (one per repetition)
        num_segments = len(output_df)
        num_events = len(event_labels)

        # Calculate segments per event
        if num_segments % num_events == 0:
            segments_per_event = num_segments // num_events

            # Create label list by repeating each label segments_per_event times
            label_list = []
            for label in event_labels:
                label_list.extend([label] * segments_per_event)

            output_df['event_label'] = label_list
            print(f"Added event labels: {num_events} events, {segments_per_event} segments per event")
        else:
            print(f"Warning: Number of segments ({num_segments}) is not evenly divisible by number of events ({num_events})")
            print(f"Skipping event label assignment")

    # Save to CSV
    output_df.to_csv(output, index=False)
    print(f"Processed {len(output_df)} segments")
    print(f"Output saved to {output}")
    return output_df


# Example usage
if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Preprocess CSV file to extract GPI2=1 segments and calculate energy"
    )
    parser.add_argument("--input", help="Path to input CSV file")
    parser.add_argument("--output", help="Path to output CSV file")
    parser.add_argument("--event-labels", help="Path to JSON file containing event labels (optional)")

    args = parser.parse_args()

    # Load event labels if provided
    event_labels = None
    if args.event_labels:
        try:
            with open(args.event_labels, 'r') as f:
                event_labels = json.load(f)
            print(f"Loaded {len(event_labels)} event labels from {args.event_labels}")
        except Exception as e:
            print(f"Warning: Could not load event labels from {args.event_labels}: {e}")

    result_df = preprocess_csv(args.input, args.output, event_labels=event_labels)

    # Display the results
    print("\nPreprocessed data:")
    print(result_df)
