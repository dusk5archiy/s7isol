from lib.wezterm import ProgramTab, WeztermSpawner
from src_wezterm.config import Settings


def run(argv: list[str]):
    program_tabs: list[ProgramTab] = [
        ProgramTab(
            title="wayland",
            command="bash cmd/main.sh -m src_ui --use-wayland 1",
        ),
        ProgramTab(
            title="x11",
            command="bash cmd/main.sh -m src_ui --use-wayland 0",
        ),
    ]

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
