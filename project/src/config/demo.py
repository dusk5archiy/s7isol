from pathlib import Path
from pydantic import BaseModel
from src.utils.config import get_config
from . import get_filename


class _Config(BaseModel, frozen=True):
    message: str


c = get_config(get_filename(Path(__file__).stem), _Config)

__all__ = ["c"]
