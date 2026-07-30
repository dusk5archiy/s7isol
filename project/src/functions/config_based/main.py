from __future__ import annotations
from pydantic import BaseModel


class ConfigBased:
    class Config(BaseModel):
        def build(self):
            return ConfigBased(self)

    def __init__(self, config: Config) -> None:
        self._config = config
