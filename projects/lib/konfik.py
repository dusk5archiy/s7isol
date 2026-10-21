import json
from abc import ABC, abstractmethod
from collections.abc import Sequence
from pathlib import Path
from typing import override

import yaml
from pydantic import BaseModel, TypeAdapter


def load_content(file: Path) -> object:
    suffix = file.suffix.lower()
    with file.open("r", encoding="utf-8") as f:
        if suffix == ".json":
            data = json.load(f)
        elif suffix in (".yaml", ".yml"):
            data = yaml.safe_load(f)
        elif suffix in (".env"):
            from dotenv import dotenv_values

            data = dotenv_values(file)
        else:
            raise ValueError(f"[-- error --] unsupported file extension: '{suffix}'")

    return data


def write_content(data: object, file: Path) -> None:
    suffix = file.suffix.lower()
    with file.open("w", encoding="utf-8") as f:
        if suffix == ".json":
            json.dump(data, f, indent=2, ensure_ascii=False)
        elif suffix in (".yaml", ".yml"):
            yaml.safe_dump(data, f, sort_keys=False, allow_unicode=True)
        else:
            raise ValueError(f"[-- error --] unsupported file extension: '{suffix}'")


def load_object[T: BaseModel](cls: type[T], file: Path) -> T:
    raw_data = load_content(file)
    adapter = TypeAdapter(cls)
    return adapter.validate_python(raw_data)


def load_list[T: BaseModel](cls: type[T], file: Path) -> list[T]:
    raw_data = load_content(file)
    if not isinstance(raw_data, list):
        raise TypeError(
            f"[-- error --] expected file content to be a list, got '{type(raw_data).__name__}'"
        )

    adapter = TypeAdapter(list[cls])
    return adapter.validate_python(raw_data)


# ==============================================================================
def translate_path(file: str, dot_extension: str) -> Path:
    project_folder = Path.cwd()
    parts = Path(file).relative_to(project_folder).parts
    config_path = (Path.cwd() / "settings" / (".".join(parts))).with_suffix(
        suffix=dot_extension
    )
    return config_path


# ------------------------------------------------------------------------------
class BaseSettings(ABC):
    @abstractmethod
    def get_data(self) -> dict: ...

    @property
    @abstractmethod
    def is_strict(self) -> bool: ...


# ------------------------------------------------------------------------------
class YamlSettings(BaseSettings):
    def __init__(self, path: str | Path):
        self.path: Path = Path(path)

    @classmethod
    def from_dunder_file(cls, dunder_file: str):
        path = translate_path(file=dunder_file, dot_extension=".yaml")
        return cls(path=path)

    @property
    @override
    def is_strict(self) -> bool:
        return True

    @override
    def get_data(self):
        if not self.path.exists():
            return {}

        data = load_content(self.path)
        assert isinstance(data, dict)

        return data


class JsonSettings(BaseSettings):
    def __init__(self, path: str | Path):
        self.path: Path = Path(path)

    @classmethod
    def from_dunder_file(cls, dunder_file: str):
        path = translate_path(file=dunder_file, dot_extension=".json")
        return cls(path=path)

    @property
    @override
    def is_strict(self) -> bool:
        return True

    @override
    def get_data(self):
        if not self.path.exists():
            return {}

        data = load_content(self.path)
        assert isinstance(data, dict)

        return data


class DotenvSettings(BaseSettings):
    def __init__(self, path: str | Path, prefix: str = ""):
        self.path: Path = Path(path)
        self.prefix = prefix.upper()

    @classmethod
    def from_dunder_file(cls, dunder_file: str):
        path = translate_path(file=dunder_file, dot_extension=".env")
        return cls(path=path)

    @property
    @override
    def is_strict(self) -> bool:
        return True

    @override
    def get_data(self):
        if not self.path.exists():
            return {}

        data = load_content(self.path)
        assert isinstance(data, dict)
        data = {
            k.upper().removeprefix(self.prefix).lower(): v
            for k, v in data.items()
            if k.upper().startswith(self.prefix)
        }
        return data


class ShellSettings(BaseSettings):
    def __init__(self, prefix: str = ""):
        self.prefix = prefix.upper()

    @property
    @override
    def is_strict(self) -> bool:
        return False

    @override
    def get_data(self):
        import os

        data = dict(os.environ)
        data = {
            k.upper().removeprefix(self.prefix).lower(): v
            for k, v in data.items()
            if k.upper().startswith(self.prefix)
        }
        return data


# ------------------------------------------------------------------------------
def get_settings[T: BaseModel](
    cls: type[T],
    settings_list: Sequence[BaseSettings] = [],
) -> T:
    data = {}

    for settings in settings_list:
        raw_data = settings.get_data()

        if settings.is_strict:
            data |= raw_data
        else:
            data |= {k: v for k, v in raw_data.items() if k in cls.model_fields}

    return cls.model_validate(data)
