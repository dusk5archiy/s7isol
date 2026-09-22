import json
from pathlib import Path

import yaml
from pydantic import BaseModel, TypeAdapter


def load_list[T: BaseModel](cls: type[T], file: Path) -> list[T]:
    suffix = file.suffix.lower()

    with file.open("r", encoding="utf-8") as f:
        if suffix == ".json":
            raw_data = json.load(f)
        elif suffix in (".yaml", ".yml"):
            raw_data = yaml.safe_load(f)
        else:
            raise ValueError(f"[-- error --] unsupported file extension: '{suffix}'")

    if not isinstance(raw_data, list):
        raise TypeError(
            f"[-- error --] expected file content to be a list, got '{type(raw_data).__name__}'"
        )

    adapter = TypeAdapter(list[cls])
    return adapter.validate_python(raw_data)


def export(model: BaseModel, file: Path):
    import yaml

    with open(file, "w") as f:
        if file.suffix in (".yaml", ".yml"):
            yaml.dump(model.model_dump(), f, sort_keys=False)
