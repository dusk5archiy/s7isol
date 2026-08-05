#!/bin/bash

skj nvim/install-core
skj nvim/lazy
skj nvim/init
skj nvim/dump

nvim --headless "+Lazy! sync" +qa
