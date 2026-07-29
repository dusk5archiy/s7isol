#!/bin/bash

$S7ISOL_SUDO npm -g install @anthropic-ai/claude-code
claude install
$S7ISOL_SUDO npm -g uninstall @anthropic-ai/claude-code
