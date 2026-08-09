from __future__ import annotations
from pydantic import BaseModel
from src.config.base import Config as BaseConfig, c

__all__ = ["BasePlugin"]


class BasePlugin:
    class Config(BaseModel):
        c: BaseConfig = c

        def build(self):
            return BasePlugin(self)

    def __init__(self, config: Config) -> None:
        self.config = config
