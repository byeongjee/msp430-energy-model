"""Exception hierarchy for the measurement scripts.

Mirrors ``ckpt/errors.py`` in the bao repository so that the device modules
shared with it stay mergeable.
"""

from __future__ import annotations


class MeasurementError(Exception):
    """Base class for all measurement script errors."""


class DeviceError(MeasurementError):
    """A device interaction failed."""
