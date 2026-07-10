#!/bin/bash

# ------------------------------------------------------------------------------

ssh -o IdentitiesOnly=yes -i "$HOME/.ssh/id_ed25519" git@github.com
