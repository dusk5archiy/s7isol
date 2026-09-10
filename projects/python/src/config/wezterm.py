from pathlib import Path

from lib.konfik import ShellSettings, get_settings
from pydantic import BaseModel


class SettingsCls(BaseModel):
    log_dir: Path | None = None


Settings = get_settings(
    SettingsCls,
    [
        ShellSettings(),
    ],
)
