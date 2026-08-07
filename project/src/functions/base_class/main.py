from __future__ import annotations
from pydantic import BaseModel


class BaseClass:
    class Config(BaseModel):
        def build(self):
            return BaseClass(self)

    def __init__(self, config: Config) -> None:
        self._config = config
