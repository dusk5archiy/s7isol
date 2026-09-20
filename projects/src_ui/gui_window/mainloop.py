from __future__ import annotations

import sys
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .main import GuiWindow


def mainloop(self: GuiWindow):
    import signal

    runtime = self.runtime
    window = runtime.window
    app = runtime.app

    assert window is not None and app is not None
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    window.show()
    sys.exit(app.exec())
