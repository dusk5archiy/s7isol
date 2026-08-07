from __future__ import annotations

import argparse

from pydantic import BaseModel
from src.config.demo import c


class CliArgs(BaseModel):
    @classmethod
    def parse(cls, argv: list[str]):
        parser = argparse.ArgumentParser()
        parsed, argv = parser.parse_known_args(argv)
        return CliArgs(**vars(parsed)), argv


def run(argv: list[str]) -> None:
    print(c.message)
