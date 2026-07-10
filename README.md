# S7ISOL

## Introduction

- This project is for creating isolated Ubuntu profiles.

## Initialization

- `cd` to the project root folder.
- Run `bash bin/init.sh` to create `.pre.env` and `.post.env` files
in the project root folder.
- Modify `S7ISOL_ROOT` in `.pre.env` to the folder that will contain the new profile.

---

If you want to run in a new Wezterm window:

- If Wezterm is not installed, run `bash bin/install/wezterm.sh` to install Wezterm.
- Modify `.pre.env`:

```bash
S7ISOL_RUN_FN="bash bin/run/wezterm.sh"
```

---

If you want to run in your current terminal:

- Modify `.pre.env`:

```bash
S7ISOL_RUN_FN=bash
```

---

You can modify or add new functions in `.env` file, and set
`S7ISOL_RUN_FN` to your command.

---

If you want to keep using your VSCode profile, ensure these lines exist
in `.pre.env` (not `.post.env`):

```bash
export YOUR_VSCODE_USER_DATA_DIR="$XDG_CONFIG_HOME/Code"
export YOUR_VSCODE_EXTENSIONS_DIR="$HOME/.vscode/extensions"
```

And run `s7isol code`, not `code`, to use your current VSCode profile.

## Start

- `cd` to the project root folder.
- Run `bash start.sh`
- Deep dive into the `s7isol` repository for more features.
