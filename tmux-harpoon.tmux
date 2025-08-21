# TMUX Plugin: tmux-harpoon
# Author: mxm-ssdia
# Description: Minimal harpoon-style navigation popup for tmux

# Show session:window in status-right
set -g status-right '#S:#I'

# Bind prefix+h to run our script
# bind-key h display-popup -E "$HOME/projects/tmux-harpoon/scripts/main.sh"
bind-key h display-popup -E "#{plugin_path}/scripts/main.sh"


# Show a message when the plugin is loaded
display-message "✅ tmux-harpoon loaded! (prefix+h to trigger)"
