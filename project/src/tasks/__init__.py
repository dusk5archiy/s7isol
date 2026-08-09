from __future__ import annotations

import argparse
import importlib
import pkgutil

from pydantic import BaseModel


class Cli(BaseModel):
    component: str

    @classmethod
    def parse(cls, argv: list[str]):
        components = get_component_names()
        parser = argparse.ArgumentParser()
        parser.add_argument("component", choices=components)

        parsed, argv = parser.parse_known_args(argv)
        return Cli(**vars(parsed)), argv


def run(argv: list[str]) -> None:
    cli, argv = Cli.parse(argv)
    component = cli.component
    target_module = f".{component}"
    node_mod = importlib.import_module(target_module, package=__name__)
    node_mod.run(argv)


def get_component_names() -> list[str]:
    return [
        m.name for m in pkgutil.iter_modules(__path__) if not m.name.startswith("_")
    ]
