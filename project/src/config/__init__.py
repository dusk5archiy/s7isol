from pydantic import BaseModel
from typing import Type
import yaml


def get_config[T: BaseModel](stem: str, config_cls: Type[T]) -> T:
    with open(f"configs/config/{stem}.yaml", encoding="utf-8") as f:
        data = yaml.safe_load(f)
        c = config_cls.model_validate(data)

    return c
