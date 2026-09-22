from pydantic import BaseModel


class BaseCli(BaseModel):
    @classmethod
    def create_parser(cls):
        import argparse

        parser = argparse.ArgumentParser()
        return parser

    @classmethod
    def parse(cls, argv: list[str]):
        args, argv = cls.create_parser().parse_known_args(argv)
        return cls.model_validate(vars(args)), argv
