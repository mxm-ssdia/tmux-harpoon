# TMUX Plugin: tmux-harpoon
# Author: mxm-ssdia
# Description: Minimal harpoon-style navigation popup for tmux

# --- Status Bar Settings ---
# Start with status bar hidden
set -g status off

# Toggle status bar on/off with prefix+b
bind-key b set-option -g status

# Auto-hide status bar after 2 seconds if shown
set -g status 2

# --- Harpoon Popup Binding ---
# Use TPM variable expansion for plugin path
bind-key h display-popup -E "#{plugin_path}/scripts/main.sh"

# --- Plugin Loaded Message ---
display-message "✅ tmux-harpoon loaded! (prefix+h to trigger)"

