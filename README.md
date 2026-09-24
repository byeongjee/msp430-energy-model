# Energy Consumption Modeling of MSP430 Programs

This project provides tools for modeling and predicting energy consumption of
MSP430FR5994 microcontroller programs using probabilistic methods.

## Quick start

### Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [uv](https://docs.astral.sh/uv/)

### Setup

Run `uv sync`.

`pem` runs the MSP430 GCC toolchain and Julia inside a Docker image, which it
builds on first use. Run `pem` from inside the repository, and keep the files
you pass to it inside the repository.

### Reproducing the paper's results

1. Generate the training benchmarks from the instruction keys that the
   evaluated programs need:

   ```bash
   uv run pem gen-benchmarks-from-keys --keys training_data/bao_asplos27/all_keys.txt \
     --batch 10 --output-dir tmp/bao_asplos27
   ```

2. Train the model from the energy measured at 3.3 V. We already generated the
   benchmarks and measured their energy, and committed both in
   `training_data/bao_asplos27`, so this step needs no hardware:

   ```bash
   uv run pem train --files "training_data/bao_asplos27/*.{c,S}" \
     --training-segments-csv "training_data/bao_asplos27/segments/3v3/*_segments.csv" \
     --defines "NUM_REPEAT=30" --model mean_per_addressing_mode \
     --inference upper-bound-lp --intercept-special-calls --params params.json
   ```

## Others

### Energy measurement

We use Otii Ace Pro to measure energy consumption.

1. Install Otii Software from [here](https://www.qoitech.com/software/).
This will install Otii Software,
both GUI and CLI.

2. Buy Otii Automation Toolbox license from [here](https://www.qoitech.com/automation-toolbox/).

Otii requires to purchase a separate license to use the Automation Toolbox,
which is required to automate measurement through scripts.

3. Set the following environment variables:
- `OTII_SERVER_BIN`: The path to the Otii server binary.
    - In my Mac, it is installed at
    `/Applications/Otii 3.app/Contents/Resources/otii_server`
- `OTII_USERNAME`: Your Otii username (with Automation Toolbox license).
- `OTII_PASSWORD`: Your Otii password (with Automation Toolbox license).

4. Hardware setup: see [Measurement setup](docs/measurement_setup.md) for the
wiring, including the Qoitech Switchboard that isolates the ez-FET debugger
from the target while it is measured.

Now we are ready to measure energy consumption.
We assume that the program uses `include/setup.h` to toggle GPI pins for
measurement.

A typical result of the measurement script is shown in the figure below:

![Measurement result](examples/images/measurement-result-plot.png)

### Testing

Run `uv run pem test` to run the test suite.

For now, we only have a few tests for the interpreter, which are done by
comparing the output of the interpreter to the output of the GDB interpreter.
