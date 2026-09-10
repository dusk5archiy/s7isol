from lib.wezterm import ProgramTab, WeztermSpawner
from src.config.wezterm import Settings


def run(argv: list[str]):
    program_tabs: list[ProgramTab] = [
        ProgramTab(
            title="wayland",
            command="use_wayland=1 bash cmd/run.sh ui --use-wayland 1",
        ),
        ProgramTab(
            title="x11",
            command="use_wayland=0 bash cmd/run.sh ui --use-wayland 0",
        ),
    ]

    spawner = WeztermSpawner(
        config=WeztermSpawner.Config(
            log_dir=Settings.log_dir,
            program_tabs=program_tabs,
        )
    )
    spawner.mainloop()
