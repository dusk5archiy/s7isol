from lib.cli import BaseCli
from src.config.window import Settings
from src.plugins.gui_window import GuiWindow


def run(argv: list[str]):
    class Cli(BaseCli):
        use_wayland: bool

        @property
        def window_platform(self):
            return "wayland" if self.use_wayland else "xcb"

        @classmethod
        def parser(cls):
            import argparse

            parser = argparse.ArgumentParser()
            parser.add_argument("--use-wayland", type=str, required=True)
            return parser

    cli, _ = Cli.parse(argv)
    window = GuiWindow(
        config=GuiWindow.Config(
            style_path=Settings.style_path,
            window_platform=cli.window_platform,
            window_title=Settings.window_title,
            window_width=Settings.window_width,
            window_height=Settings.window_height,
        ),
        runtime=GuiWindow.Runtime(),
    )

    window.mainloop()
