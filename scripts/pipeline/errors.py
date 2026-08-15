"""Error type shared by the pipeline commands."""


class PipelineError(Exception):
    """A pipeline step failed. Reported by the CLI as a message plus exit code 1."""
