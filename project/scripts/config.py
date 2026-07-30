from __future__ import annotations
import argparse
import yaml
import sys

from pydantic import BaseModel


class ProjectConfig(BaseModel):
    message: str


class CliArgs(BaseModel):
    variable: str

    @classmethod
    def parse(cls, argv: list[str]):
        parser = argparse.ArgumentParser()
        parser.add_argument("variable")
        parsed, argv = parser.parse_known_args()
        return CliArgs(**vars(parsed)), argv


def main(argv: list[str]) -> None:
    args, argv = CliArgs.parse(argv)
    variable = args.variable
    with open("configs/project.yaml", encoding="utf-8") as f:
        c = ProjectConfig(**yaml.safe_load(f)).model_dump()

    assert variable in c
    print(c[variable])


if __name__ == "__main__":
    main(sys.argv[1:])
