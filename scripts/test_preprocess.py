import tempfile
import unittest
from pathlib import Path
import sys

import pandas as pd

sys.path.insert(0, str(Path(__file__).resolve().parent))
from preprocess import preprocess_csv


class TestPreprocess(unittest.TestCase):
    def test_drops_degenerate_zero_length_zero_energy_segments(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            tmpdir = Path(tmpdir)
            input_csv = tmpdir / "input.csv"
            output_csv = tmpdir / "output.csv"

            input_df = pd.DataFrame(
                {
                    "timestamp_s": [0.0, 0.0, 1.0, 2.0, 3.0],
                    "power_W": [1.0, 1.0, 0.0, 2.0, 2.0],
                    "gpi1": [1, 1, 1, 1, 1],
                    "gpi2": [1, 1, 0, 1, 1],
                }
            )
            input_df.to_csv(input_csv, index=False)

            result_df = preprocess_csv(
                input_csv, output_csv, event_labels=["bench_real_segment"]
            )

            self.assertEqual(len(result_df), 1)
            self.assertAlmostEqual(result_df.iloc[0]["duration_s"], 1.0)
            self.assertAlmostEqual(result_df.iloc[0]["energy_nJ"], 2.0e9)
            self.assertEqual(result_df.iloc[0]["event_label"], "bench_real_segment")


if __name__ == "__main__":
    unittest.main()
