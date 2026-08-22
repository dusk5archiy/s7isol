import json
import os

S7ISOL = os.environ["S7ISOL"]
NVIM_CONFIG_DIR = os.environ["NVIM_CONFIG_DIR"]

S7ISOL_FILE = f"{S7ISOL}/config/nvim/lazyvim.json"
TARGET_FILE = f"{NVIM_CONFIG_DIR}/lazyvim.json"

with open(S7ISOL_FILE) as f:
    s7isol_dict = json.load(f)

with open(TARGET_FILE, "w") as g:
    json.dump(s7isol_dict, g, indent=2)
