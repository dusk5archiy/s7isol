from pathlib import Path

import yaml
from pydantic import BaseModel


def config_path_from_module(module_file: str) -> str:
    module_path = Path(module_file).resolve()
    parts = module_path.parts
    if "src" in parts:
        src_idx = parts.index("src")
        config_parts = parts[:src_idx] + ("configs",) + parts[src_idx + 1 :]
    else:
        config_parts = parts
    yaml_path = Path(*config_parts).with_suffix(".yaml")
    return str(yaml_path)


def get_config[T: BaseModel](filename: str, config_cls: type[T]) -> T:
    with open(filename, encoding="utf-8") as f:
        data = yaml.safe_load(f)
        c = config_cls.model_validate(data)

    return c


def get_config_from_module[T: BaseModel](module_file: str, config_cls: type[T]) -> T:
    filename = config_path_from_module(module_file)
    return get_config(filename, config_cls)
