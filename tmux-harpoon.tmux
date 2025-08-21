#!/usr/bin/env bash
# TMUX Plugin: tmux-harpoon
# Author: mxm-ssdia
# Description: Minimal harpoon-style navigation popup for tmux

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Bind prefix+h to run our script
tmux bind-key h run-shell "$CURRENT_DIR/scripts/hello.sh"

# Show a message when the plugin is loaded
tmux display-message "✅ tmux-harpoon loaded! (prefix+h to trigger)"
