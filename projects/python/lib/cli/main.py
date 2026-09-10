from pydantic import BaseModel


class BaseCli(BaseModel):
    @classmethod
    def parser(cls):
        import argparse

        parser = argparse.ArgumentParser()
        return parser

    @classmethod
    def parse(cls, argv: list[str]):
        args, argv = cls.parser().parse_known_args(argv)
        return cls.model_validate(vars(args)), argv


__all__ = ["BaseCli"]
