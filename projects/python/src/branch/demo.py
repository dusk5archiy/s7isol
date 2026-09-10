from __future__ import annotations

from src.config.base import Settings
from src.plugins.base import BasePlugin


def run(argv: list[str]) -> None:
    plugin = BasePlugin(config=BasePlugin.Config(message=Settings.message))
    plugin()
