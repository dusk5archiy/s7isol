from pathlib import Path

from lib.cli import BaseCli
from lib.pydanplus import load_list
from lib.wezterm import ProgramTab, WeztermSpawner
from src_wezterm.config import Settings


def run(argv: list[str]):
    class Cli(BaseCli):
        file: Path

        @classmethod
        def create_parser(cls):
            parser = super().create_parser()
            parser.add_argument("file", type=str)
            return parser

    cli, _ = Cli.parse(argv)

    program_tabs: list[ProgramTab] = load_list(ProgramTab, cli.file)
    spawner = WeztermSpawner(
        config=WeztermSpawner.Config(
            log_dir=Settings.log_dir,
            program_tabs=program_tabs,
        )
    )
    spawner.mainloop()


if __name__ == "__main__":
    import sys

    run(sys.argv[1:])
