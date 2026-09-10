from __future__ import annotations

import argparse
import importlib
import importlib.util
import pkgutil


def dunder_init_run(module_names: list[str]):
    def run(argv: list[str]) -> None:
        parser = argparse.ArgumentParser()
        parser.add_argument("component")
        args, argv = parser.parse_known_args(argv)

        component_exists = False
        for module_name in module_names:
            spec = importlib.util.find_spec(module_name)
            assert spec is not None
            dunder_path = spec.submodule_search_locations
            assert dunder_path is not None
            components = [
                m.name
                for m in pkgutil.iter_modules(path=dunder_path)
                if not m.name.startswith("_")
            ]

            component = args.component

            if component not in components:
                continue

            node_mod = importlib.import_module(
                f".{args.component}", package=module_name
            )
            node_mod.run(argv)
            component_exists = True
            break

        assert component_exists

    return run


__all__ = ["dunder_init_run"]
