from pydantic import BaseModel
from typing import Type
import yaml


def get_config[T: BaseModel](filename: str, config_cls: Type[T]) -> T:
    with open(filename, encoding="utf-8") as f:
        data = yaml.safe_load(f)
        c = config_cls.model_validate(data)

    return c
