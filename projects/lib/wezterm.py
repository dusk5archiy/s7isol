import json
import re
import subprocess
from pathlib import Path

from pydantic import BaseModel


class ProgramTab(BaseModel):
    title: str
    command: str


class WeztermSpawner:
    class Config(BaseModel):
        log_dir: Path | None = None
        program_tabs: list[ProgramTab]

    def __init__(self, config: Config) -> None:
        self.config = config

    def mainloop(self):
        config = self.config
        window_id = None

        if config.log_dir:
            config.log_dir.mkdir(parents=True, exist_ok=True)

        for i, program_tab in enumerate(config.program_tabs):
            if not window_id:
                target_flags = ["--new-window"]
            else:
                target_flags = ["--window-id", str(window_id)]

            title_escaped = program_tab.title.replace("'", "'\\''")
            title_cmd = f"printf '\033]0;%s\007' '{title_escaped}'"

            if config.log_dir:
                log = self._log_path(program_tab.title, i)
                shell_cmd = (
                    f"{title_cmd}; "
                    f"stdbuf -oL -eL bash -c '{program_tab.command}' 2>&1 | tee {log}; "
                    f"exec bash"
                )
            else:
                shell_cmd = f"{title_cmd}; {program_tab.command}; exec bash"

            spawn_args = ["wezterm", "cli", "spawn"] + target_flags
            spawn_args.extend(["--cwd", str(Path.cwd())])
            spawn_args.extend(["--", "bash", "-c", shell_cmd])

            result = subprocess.run(
                spawn_args, capture_output=True, text=True, check=True
            )
            pane_id = result.stdout.strip()

            if window_id:
                continue

            list_result = subprocess.run(
                ["wezterm", "cli", "list", "--format", "json"],
                capture_output=True,
                text=True,
                check=True,
            )
            panes = json.loads(list_result.stdout)
            for pane in panes:
                if str(pane.get("pane_id")) == str(pane_id):
                    window_id = pane.get("window_id")
                    break

    def _log_path(self, title: str, index: int) -> Path:
        """Filesystem-safe log name from the tab title (slashes for the FS only)."""
        config = self.config
        assert config.log_dir is not None
        safe = re.sub(r"[^A-Za-z0-9._-]+", "_", title).strip("_") or f"pane_{index}"
        return config.log_dir / f"{safe}.log"
