#!/usr/bin/env bash

# get all sessions and windows
mapfile -t sessions < <(tmux list-sessions -F '#S')

session_index=0
window_index=0

while true; do
    clear
    echo "Tmux Harpoon Navigator"
    echo "======================"
    echo "[h/l] move tab  [Ctrl-p/Ctrl-n] move session  [Enter] switch  [q] quit"
    echo

    for i in "${!sessions[@]}"; do
        s="${sessions[$i]}"
        mapfile -t wins < <(tmux list-windows -t "$s" -F '#I:#W')

        line="$s: "
        for j in "${!wins[@]}"; do
            idx="${wins[$j]%%:*}"
            name="${wins[$j]#*:}"
            if [[ $i -eq $session_index && $j -eq $window_index ]]; then
                line+="(${name})-"
            else
                line+="${name}-"
            fi
        done
        line="${line%-}" # trim last dash
        echo "$line"
    done

    read -rsn1 key
    case "$key" in
    h) ((window_index = (window_index - 1 + $(tmux list-windows -t "${sessions[$session_index]}" | wc -l)) % $(tmux list-windows -t "${sessions[$session_index]}" | wc -l))) ;;
    l) ((window_index = (window_index + 1) % $(tmux list-windows -t "${sessions[$session_index]}" | wc -l))) ;;
    $'\x10') # Ctrl-p
        ((session_index = (session_index - 1 + ${#sessions[@]}) % ${#sessions[@]}))
        window_index=0
        ;;
    $'\x0e') # Ctrl-n
        ((session_index = (session_index + 1) % ${#sessions[@]}))
        window_index=0
        ;;
    "") # Enter
        sel_session="${sessions[$session_index]}"
        sel_window=$(tmux list-windows -t "$sel_session" -F '#I' | sed -n "$((window_index + 1))p")
        tmux switch-client -t "$sel_session"
        tmux select-window -t "$sel_session:$sel_window"
        exit 0
        ;;
    q) exit 0 ;;
    esac
done
