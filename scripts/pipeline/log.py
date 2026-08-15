"""Console logging for the pipeline commands."""

import sys

_RED = "\033[0;31m"
_GREEN = "\033[0;32m"
_YELLOW = "\033[1;33m"
_BLUE = "\033[0;34m"
_NC = "\033[0m"


def info(message: str = "") -> None:
    print(f"{_BLUE}[INFO]{_NC} {message}")


def success(message: str) -> None:
    print(f"{_GREEN}[SUCCESS]{_NC} {message}")


def error(message: str) -> None:
    print(f"{_RED}[ERROR]{_NC} {message}", file=sys.stderr)


def warn(message: str) -> None:
    print(f"{_YELLOW}[WARN]{_NC} {message}", file=sys.stderr)


def step(title: str) -> None:
    rule = f"{_YELLOW}======================================{_NC}"
    print(f"\n{rule}\n{_YELLOW}{title}{_NC}\n{rule}")
