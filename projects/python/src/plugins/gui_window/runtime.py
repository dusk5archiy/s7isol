from dataclasses import dataclass

from PySide6.QtWidgets import QApplication, QMainWindow


@dataclass(kw_only=True)
class Runtime:
    app: QApplication | None = None
    window: QMainWindow | None = None
