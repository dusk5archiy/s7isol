from pydantic import BaseModel

from src.utils.config import get_config_from_module


class Config(BaseModel, frozen=True):
    message: str


c = get_config_from_module(__file__, Config)
