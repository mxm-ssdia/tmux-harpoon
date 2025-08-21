#!/usr/bin/env bash

# # Show a popup with all windows
# tmux display-popup -E "
#     echo '📂 Tmux Harpoon Navigator';
#     echo '==========================';
#     echo;
#     tmux list-windows -F '#I: #W (session: #{session_name})';
#     echo;
#     echo 'Press q to quit';
#     read -n 1 key;
#     if [[ \$key =~ [0-9] ]]; then
#         tmux select-window -t \$key
#     fi
# "
#
# List sessions & windows
tmux list-windows -a -F "#S:#I:#W" | fzf --delimiter=: --with-nth=2,3 --preview 'echo Session: {1}'

# When user picks one, parse it:
selection=$(tmux list-windows -a -F "#S:#I" | fzf)
session=$(echo "$selection" | cut -d: -f1)
window=$(echo "$selection" | cut -d: -f2)

# Switch
[ -n "$selection" ] && tmux switch-client -t "$session" && tmux select-window -t "$window"
