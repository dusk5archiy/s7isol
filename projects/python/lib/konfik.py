from abc import ABC, abstractmethod
from collections.abc import Sequence
from pathlib import Path
from typing import override

from pydantic import BaseModel


# ------------------------------------------------------------------------------
def export_yaml(model: BaseModel, file: Path):
    import yaml

    with open(file, "w") as f:
        yaml.dump(model.model_dump(), f, sort_keys=False)


# ------------------------------------------------------------------------------
def translate_path(file: str, dot_extension: str) -> Path:
    parts = Path(file).resolve().parts

    src_idx = parts.index("src")
    sub_path = Path(*parts[src_idx + 1 :])
    config_path = (Path.cwd() / "configs" / sub_path).with_suffix(suffix=dot_extension)

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

        import yaml

        with open(self.path, encoding="utf-8") as f:
            data = yaml.safe_load(f)
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

        import json

        with open(self.path, encoding="utf-8") as f:
            data = json.load(f)
            assert isinstance(data, dict)

        return data


class DotenvSettings(BaseSettings):
    def __init__(self, path: str | Path, prefix: str = ""):
        self.path: Path = Path(path)
        self.prefix = prefix

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

        from dotenv import dotenv_values

        data = dotenv_values(self.path)
        data = {
            k.removeprefix(self.prefix): v
            for k, v in data.items()
            if k.startswith(self.prefix)
        }
        return data


class ShellSettings(BaseSettings):
    def __init__(self, prefix: str = ""):
        self.prefix = prefix

    @property
    @override
    def is_strict(self) -> bool:
        return False

    @override
    def get_data(self):
        import os

        data = dict(os.environ)
        data = {
            k.removeprefix(self.prefix): v
            for k, v in data.items()
            if k.startswith(self.prefix)
        }
        return data


# ------------------------------------------------------------------------------
def get_settings[T: BaseModel](
    cls: type[T], settings_list: Sequence[BaseSettings]
) -> T:
    data = {}

    for settings in settings_list:
        raw_data = settings.get_data()

        if settings.is_strict:
            data |= raw_data
        else:
            data |= {k: v for k, v in raw_data.items() if k in cls.model_fields}

    return cls.model_validate(data)
