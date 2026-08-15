"""Handling of the space-separated compiler macro lists (e.g. "FOO=1 BAR")."""


def to_flags(defines: str) -> list[str]:
    """Turn "FOO=1 BAR" into ["-DFOO=1", "-DBAR"]."""
    return [f"-D{define}" for define in defines.split()]


def extract(defines: str, name: str) -> str | None:
    """Return the value of one macro, or None when it is not in the list."""
    for define in defines.split():
        macro, separator, value = define.partition("=")
        if separator and macro == name:
            return value
    return None


def override(defines: str, name: str, value: str) -> str:
    """Replace the value of one macro, appending it when it is not in the list."""
    result = []
    found = False
    for define in defines.split():
        macro, separator, _ = define.partition("=")
        if separator and macro == name:
            result.append(f"{name}={value}")
            found = True
        else:
            result.append(define)
    if not found:
        result.append(f"{name}={value}")
    return " ".join(result)
