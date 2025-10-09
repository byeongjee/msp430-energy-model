#!/usr/bin/env python3
import pandas as pd
from scipy import integrate
import argparse


def preprocess_csv(input, output):
    """
    Preprocess CSV file to extract segments where GPI2=1 and calculate energy.
    Parameters:
    input_file: Path to input CSV file
    output_file: Path to output CSV file
    """
    # Read the CSV file
    df = pd.read_csv(input)
    # Forward fill the GPI2 column to handle empty values
    df["gpi2"] = df["gpi2"].fillna(method="ffill")
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

    args = parser.parse_args()

    result_df = preprocess_csv(args.input, args.output)

    # Display the results
    print("\nPreprocessed data:")
    print(result_df)
