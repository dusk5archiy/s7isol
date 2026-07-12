# S7ISOL

## Introduction

Targets:

- Ubuntu 26.04 LTS

This project is for creating a minimal dev stack with Wezterm, LazyVim, Yazi,
and more. Deep dive into the `s7isol` repository for more features.

You can apply this system to your current Ubuntu profile, or you can create
a new profile (with a new `HOME` variable).

Before running the scripts, please investigate this project to understand
its effects to your system. You are responsible for the changes.

## Applying to your current profile

- `cd` to the project root folder.
- Note: If Wezterm is not installed,
  the following script will install Wezterm automatically.
- Run `bash local.sh`. Enjoy.

## Creating new profiles

### Initialization

- `cd` to the project root folder.
- Run `bash bin/init.sh` to create `.pre.env` and `.post.env` files
in the project root folder.
- Modify `S7ISOL_ROOT` in `.pre.env` to the folder that will contain the new profile.

---

If you want to keep using your VSCode profile, ensure these lines exist
in `.pre.env` (not `.post.env`):

```bash
export S7ISOL_VSCODE_USER_DATA_DIR="$XDG_CONFIG_HOME/Code"
export S7ISOL_VSCODE_EXTENSIONS_DIR="$HOME/.vscode/extensions"
```

And run `s7isol code`, not `code`, to use your current VSCode profile.

### Start

- `cd` to the project root folder.
- Run `bash start.sh`
