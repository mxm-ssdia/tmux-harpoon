# TMUX Plugin: tmux-harpoon
# Author: mxm-ssdia
# Description: Minimal harpoon-style navigation popup for tmux

# Show session:window in status-right
set -g status-right '#S:#I'

set -g @tmux-harpoon-dir "$TMUX_PLUGIN_MANAGER_PATH/tmux-harpoon"

bind-key h display-popup -E "#(@tmux-harpoon-dir)/scripts/main.sh"



# Show a message when the plugin is loaded
display-message "✅ tmux-harpoon loaded! (prefix+h to trigger)"
