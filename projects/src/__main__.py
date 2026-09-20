from __future__ import annotations

from src.config import Settings
from src.plugin import Plugin


def run(argv: list[str]) -> None:
    plugin = Plugin(config=Plugin.Config(message=Settings.message))
    plugin()


if __name__ == "__main__":
    import sys

    run(sys.argv[1:])
