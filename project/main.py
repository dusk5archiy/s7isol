from __future__ import annotations

import argparse
import importlib
import pkgutil
import sys

from pydantic import BaseModel


class CliArgs(BaseModel):
    task: str

    @classmethod
    def parse(cls, argv: list[str]):
        tasks = get_task_names()
        parser = argparse.ArgumentParser()
        parser.add_argument(
            "task",
            choices=tasks,
            type=str,
        )
        parsed, argv = parser.parse_known_args()
        return CliArgs(**vars(parsed)), argv


def main(argv: list[str]) -> None:
    args, argv = CliArgs.parse(argv)
    target_module = f"src.tasks.{args.task}"
    node_mod = importlib.import_module(target_module)
    node_mod.run(argv)


# ------------------------------------------------------------------------------


def get_task_names() -> list[str]:
    import src.tasks

    return [
        m.name
        for m in pkgutil.iter_modules(src.tasks.__path__)
        if not m.name.startswith("_")
    ]


if __name__ == "__main__":
    main(sys.argv[1:])
