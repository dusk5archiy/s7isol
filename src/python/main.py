import sys
from dataclasses import dataclass
import argparse


@dataclass
class CliArgs:
    @classmethod
    def parse(cls, argv: list[str]):
        parser = argparse.ArgumentParser()
        parsed, argv = parser.parse_known_args()
        return CliArgs(**vars(parsed)), argv


def main(argv: list[str]):
    pass


if __name__ == "__main__":
    main(sys.argv[1:])
