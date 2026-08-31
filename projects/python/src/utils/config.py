from pathlib import Path

import yaml
from pydantic import BaseModel


def config_path_from_module(module_file: str) -> str:
    parts = Path(module_file).resolve().parts

    src_idx = parts.index("src")
    sub_path = Path(*parts[src_idx + 1 :])
    config_path = (Path.cwd() / "configs" / sub_path).with_suffix(".yaml")

    return str(config_path)


def from_yaml[T: BaseModel](filename: str, config_cls: type[T]) -> T:
    with open(filename, encoding="utf-8") as f:
        data = yaml.safe_load(f)
        c = config_cls.model_validate(data)

    return c


def get_config_from_module[T: BaseModel](module_file: str, config_cls: type[T]) -> T:
    filename = config_path_from_module(module_file)
    return from_yaml(filename, config_cls)
