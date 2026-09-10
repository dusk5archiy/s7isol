import os

from PySide6.QtWidgets import QApplication, QMainWindow


class GuiWindow:
    from .config import Config
    from .mainloop import mainloop
    from .runtime import Runtime

    def __init__(self, config: Config, runtime: Runtime):
        self.config = config
        self.runtime = runtime

        if runtime.app is None:
            os.environ["QT_QPA_PLATFORM"] = config.window_platform
            runtime.app = QApplication()

        if runtime.window is None:
            runtime.window = QMainWindow()
            runtime.window.setWindowTitle(config.window_title)
            runtime.window.resize(config.window_width, config.window_height)

            if config.style_path.exists():
                runtime.window.setStyleSheet(config.style_path.read_text())


__all__ = ["GuiWindow"]
