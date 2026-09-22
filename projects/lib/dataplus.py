import json
from pathlib import Path

import yaml
from pydantic import BaseModel, TypeAdapter


def load_content(file: Path) -> object:
    suffix = file.suffix.lower()
    with file.open("r", encoding="utf-8") as f:
        if suffix == ".json":
            data = json.load(f)
        elif suffix in (".yaml", ".yml"):
            data = yaml.safe_load(f)
        else:
            raise ValueError(f"[-- error --] unsupported file extension: '{suffix}'")

    return data


def load_list[T: BaseModel](cls: type[T], file: Path) -> list[T]:
    raw_data = load_content(file)
    if not isinstance(raw_data, list):
        raise TypeError(
            f"[-- error --] expected file content to be a list, got '{type(raw_data).__name__}'"
        )

    adapter = TypeAdapter(list[cls])
    return adapter.validate_python(raw_data)
