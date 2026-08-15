"""Flash the MSP430 target via mspdebug.

Mirrors ``ckpt/device/flash.py`` in the bao repository, without its NVM
readback helpers.
"""

from __future__ import annotations

import re
import subprocess
import threading
from pathlib import Path

from ..errors import DeviceError

_PROG_DONE_RE = re.compile(r"Done, \d+ bytes total")
_PROG_ERROR_MARKERS = ("failed", "error:", "Error:", "usage:")


class HeldFlashSession:
    """An mspdebug session kept open after programming.

    While the session is open the target stays halted under JTAG, so no
    GPIO pulses are emitted. ``release()`` closes the session; mspdebug's
    exit releases the target, which resets and free-runs exactly once.
    """

    def __init__(self, proc: subprocess.Popen, output_lines: list[str]) -> None:
        self._proc = proc
        self._output_lines = output_lines

    def release(self, timeout: int) -> None:
        """Close the session so the target resets and starts running."""
        if self._proc.stdin is not None:
            self._proc.stdin.close()
        try:
            # communicate() drains remaining stdout so mspdebug can exit.
            self._proc.communicate(timeout=timeout)
        except subprocess.TimeoutExpired as exc:
            self._proc.kill()
            self._proc.communicate()
            raise DeviceError(
                f"mspdebug did not exit within {timeout}s while releasing the target"
            ) from exc
        if self._proc.returncode != 0:
            raise DeviceError(
                f"mspdebug exited with {self._proc.returncode} while releasing the target: "
                f"{''.join(self._output_lines)[-500:]}"
            )

    def abort(self) -> None:
        """Kill the session without caring about target state."""
        self._proc.kill()
        self._proc.communicate()


def flash_and_hold(
    elf_path: Path,
    timeout: int,
) -> HeldFlashSession:
    """Flash ELF and keep the target halted under the open mspdebug session.

    Drives ``mspdebug tilib`` via stdin: writes ``prog <elf>`` and reads
    stdout until mspdebug reports programming completion. The session is
    left open so the target does not run; call ``release()`` on the
    returned session to reset-and-run it (e.g. after arming a capture).

    Raises DeviceError on programming failure or timeout.
    """
    proc = subprocess.Popen(
        ["mspdebug", "tilib"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    assert proc.stdin is not None and proc.stdout is not None

    # Enforce a wall-clock deadline: killing the process unblocks readline().
    timed_out = threading.Event()

    def _kill_on_timeout() -> None:
        timed_out.set()
        proc.kill()

    watchdog = threading.Timer(timeout, _kill_on_timeout)
    watchdog.start()

    lines: list[str] = []
    try:
        proc.stdin.write(f"prog {elf_path}\n")
        proc.stdin.flush()
        for line in proc.stdout:
            lines.append(line)
            if _PROG_DONE_RE.search(line):
                return HeldFlashSession(proc, lines)
            if any(marker in line for marker in _PROG_ERROR_MARKERS):
                break
        # EOF or error marker before completion.
        proc.kill()
        proc.communicate()
        if timed_out.is_set():
            raise DeviceError(f"mspdebug flash timed out after {timeout}s")
        raise DeviceError(
            f"mspdebug flash failed before completing: {''.join(lines)[-500:]}"
        )
    except BrokenPipeError as exc:
        proc.kill()
        proc.communicate()
        raise DeviceError(
            f"mspdebug flash session died: {''.join(lines)[-500:]}"
        ) from exc
    finally:
        watchdog.cancel()
