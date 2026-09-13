from __future__ import annotations

from lib.branching import dunder_init_run

if __name__ == "__main__":
    import sys

    import src.branch

    dunder_init_run(module_names=[src.branch.__name__])(sys.argv[1:])
