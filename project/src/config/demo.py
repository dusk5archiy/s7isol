from pathlib import Path
from pydantic import BaseModel
from . import get_config


class _Config(BaseModel, frozen=True):
    message: str


c = get_config(Path(__file__).stem, _Config)
__all__ = ["c"]
