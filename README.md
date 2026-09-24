# Probabilistic Energy Consumption Modeling of MSP430 Programs

This project provides tools for modeling and predicting energy consumption of
MSP430FR5994 microcontroller programs using probabilistic methods.

## Setup

Install [Docker](https://docs.docker.com/get-docker/) and
[uv](https://docs.astral.sh/uv/), then run `uv sync`.

`pem` runs the MSP430 GCC toolchain and Julia inside a Docker image, which it
builds on first use. Run `pem` from inside the repository, and keep the files
you pass to it inside the repository.

### Otii (for energy measurement only)
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

## Usage

The main entrypoint is the `pem` command, installed by `uv sync`.
Run `uv run pem --help` for a list of available commands.

The main features include:
- `train`: Train the energy model from measurement data.
- `estimate`: Estimate energy consumption of a new program using the trained model.

## Testing

Run `uv run pem test` to run the test suite.

For now, we only have a few tests for the interpreter, which are done by
comparing the output of the interpreter to the output of the GDB interpreter.
