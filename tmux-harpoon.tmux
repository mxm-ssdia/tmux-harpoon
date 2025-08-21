# TMUX Plugin: tmux-harpoon
# Author: mxm-ssdia
# Description: Minimal harpoon-style navigation popup for tmux

# Bind prefix+h to run our script
bind-key h run-shell "$HOME/projects/tmux-harpoon/scripts/main.sh"

# Show a message when the plugin is loaded
display-message "✅ tmux-harpoon loaded! (prefix+h to trigger)"
