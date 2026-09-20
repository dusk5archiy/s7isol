from dataclasses import dataclass
from pathlib import Path


@dataclass(kw_only=True)
class Config:
    style_path: Path
    window_platform: str
    window_title: str
    window_width: int
    window_height: int
