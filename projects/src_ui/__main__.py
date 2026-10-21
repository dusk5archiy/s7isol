from lib.konfik import ShellSettings, get_settings
from pydantic import BaseModel
from src_ui.config import Settings
from src_ui.gui_window import GuiWindow


def run(argv: list[str]):
    class Cli(BaseModel):
        wayland: bool = False

        @property
        def window_platform(self):
            return "wayland" if self.wayland else "xcb"

    cli = get_settings(Cli, [ShellSettings()])
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


if __name__ == "__main__":
    import sys

    run(sys.argv[1:])
