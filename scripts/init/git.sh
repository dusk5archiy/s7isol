#!/bin/bash

# ------------------------------------------------------------------------------

read -p "Name: " name_
read -p "Email: " email_

# ------------------------------------------------------------------------------

touch "$HOME/.gitconfig"
git config --global user.name "$name_"
git config --global user.email "$email_"
git config --global safe.directory '*'
git config --global init.defaultbranch main
git config --global credential.helperselector.selected "<no helper>"
git config --global --list

# ------------------------------------------------------------------------------

mkdir -p "$HOME/.ssh"
ssh-keygen -t ed25519 -C "$email_" -f "$HOME/.ssh/id_ed25519"

# ------------------------------------------------------------------------------

eval "$(ssh-agent -s)"
ssh-add "$HOME/.ssh/id_ed25519"

# ------------------------------------------------------------------------------

cat "$HOME/.ssh/id_ed25519.pub"
