#!/usr/bin/env bash

STATE_FILE="/tmp/tmux-harpoon-state"

# --- Load sessions ---
mapfile -t sessions < <(tmux list-sessions -F '#S')

# --- Restore last state if exists ---
if [[ -f "$STATE_FILE" ]]; then
    read -r session_index window_index <"$STATE_FILE"
else
    session_index=0
    window_index=0
fi

while true; do
    clear
    echo "[h/l] move tab  [Ctrl-p/Ctrl-n] move session"
    echo "[Enter] select  [c] new session  [C] new tab  [r] rename session  [R] rename tab  [q] quit"
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
        echo "$session_index $window_index" >"$STATE_FILE"
        exit 0
        ;;
    q)
        echo "$session_index $window_index" >"$STATE_FILE"
        exit 0
        ;;
    r) # rename session
        echo -n "New session name: "
        read -r newname
        [[ -n "$newname" ]] && tmux rename-session -t "${sessions[$session_index]}" "$newname"
        mapfile -t sessions < <(tmux list-sessions -F '#S')
        ;;
    R) # rename window
        echo -n "New window name: "
        read -r newname
        if [[ -n "$newname" ]]; then
            sel_session="${sessions[$session_index]}"
            sel_window=$(tmux list-windows -t "$sel_session" -F '#I' | sed -n "$((window_index + 1))p")
            tmux rename-window -t "$sel_session:$sel_window" "$newname"
        fi
        ;;
    c) # create new session
        echo -n "Session name: "
        read -r newname
        [[ -n "$newname" ]] && tmux new-session -d -s "$newname"
        mapfile -t sessions < <(tmux list-sessions -F '#S')
        ;;
    C) # create new window in current session
        sel_session="${sessions[$session_index]}"
        tmux new-window -t "$sel_session" -n "new-tab"
        ;;
    esac
done
