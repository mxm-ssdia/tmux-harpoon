#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Bind prefix+h to run our script
tmux bind-key h run-shell "$CURRENT_DIR/scripts/hello.sh"
