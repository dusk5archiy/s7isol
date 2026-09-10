from pathlib import Path

from lib.konfik import ShellSettings, YamlSettings, get_settings
from pydantic import BaseModel


class SettingsCls(BaseModel):
    window_title: str
    window_width: int
    window_height: int
    style_path: Path


Settings = get_settings(
    SettingsCls,
    [
        YamlSettings.from_dunder_file(__file__),
        ShellSettings(),
    ],
)
