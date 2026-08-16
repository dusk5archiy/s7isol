import signal
import sys
from pathlib import Path

from PySide6.QtWidgets import QApplication, QMainWindow


def run(*_):
    app = QApplication()

    signal.signal(signal.SIGINT, signal.SIG_DFL)

    window = QMainWindow()
    window.setWindowTitle("s7isol")
    window.resize(300, 200)

    if (style_path := Path("styles/app.css")).exists():
        window.setStyleSheet(style_path.read_text())

    window.show()
    sys.exit(app.exec())
