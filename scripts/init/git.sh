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
git config --global core.sshCommand "ssh -o IdentitiesOnly=yes -i $YOUR_SSH_DIR/id_ed25519"

# ------------------------------------------------------------------------------

ssh-keygen -t ed25519 -C "$email_" -f "$YOUR_SSH_DIR/id_ed25519"

# ------------------------------------------------------------------------------

eval "$(ssh-agent -s)"
ssh-add "$YOUR_SSH_DIR/id_ed25519"

# ------------------------------------------------------------------------------

cat "$YOUR_SSH_DIR/id_ed25519.pub"
