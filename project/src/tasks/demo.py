from __future__ import annotations

import argparse

from pydantic import BaseModel

from src.plugins.base import BasePlugin


class Cli(BaseModel):
    @classmethod
    def parse(cls, argv: list[str]):
        parser = argparse.ArgumentParser()
        parsed, argv = parser.parse_known_args(argv)
        return Cli.model_validate(parsed), argv


def run(argv: list[str]) -> None:
    plugin = BasePlugin.Config().build()
    plugin()
