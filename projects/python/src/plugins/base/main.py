from __future__ import annotations


class BasePlugin:
    from .classes import Config
    from .methods import __call__

    def __init__(self, config: Config):
        self.config = config


__all__ = ["BasePlugin"]
