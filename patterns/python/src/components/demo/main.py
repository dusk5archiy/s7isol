from __future__ import annotations

import argparse

from pydantic import BaseModel
from src.config.demo import c


class CliArgs(BaseModel):
    message: str

    @classmethod
    def parse(cls, argv: list[str]):
        parser = argparse.ArgumentParser()
        parser.add_argument("--message", type=str, required=True)
        parsed, argv = parser.parse_known_args(argv)
        return CliArgs(**vars(parsed)), argv


def run(argv: list[str]) -> None:
    args, argv = CliArgs.parse(argv)
    print(args.message)
    print(c.message)
