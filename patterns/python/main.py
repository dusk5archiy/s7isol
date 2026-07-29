from __future__ import annotations
import argparse
import importlib
import pkgutil
import sys

from pydantic import BaseModel


class CliArgs(BaseModel):
    component: str

    @classmethod
    def parse(cls, argv: list[str]):
        components = get_component_names()
        parser = argparse.ArgumentParser()
        parser.add_argument("component", choices=components)
        parsed, argv = parser.parse_known_args()
        return CliArgs(**vars(parsed)), argv


def main(argv: list[str]) -> None:
    args, argv = CliArgs.parse(argv)
    target_module = f"src.components.{args.component}"
    node_mod = importlib.import_module(target_module)
    node_mod.run(argv)


# ------------------------------------------------------------------------------


def get_component_names() -> list[str]:
    import src.components

    return [
        m.name
        for m in pkgutil.iter_modules(src.components.__path__)
        if not m.name.startswith("_")
    ]


if __name__ == "__main__":
    main(sys.argv[1:])
