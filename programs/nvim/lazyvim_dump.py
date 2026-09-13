import json
import os
from pathlib import Path

S7ISOL = Path(__file__).resolve().parent.parent.parent
NVIM_CONFIG_DIR = Path(os.environ["NVIM_CONFIG_DIR"])

S7ISOL_FILE = S7ISOL / "config/nvim/lazyvim.json"
TARGET_FILE = NVIM_CONFIG_DIR / "lazyvim.json"

with open(S7ISOL_FILE) as f:
    s7isol_dict = json.load(f)

with open(TARGET_FILE, "w") as g:
    json.dump(s7isol_dict, g, indent=2)
