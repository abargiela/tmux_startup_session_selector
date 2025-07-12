#!/bin/bash

return_opened_sessions_names() {
	echo -e "\nCurrently opened sessions:"
	tmux list-sessions -F '#S'
	echo -e "\nType the session name to attach, or [m] for main menu, [e] to exit:"
}

attach_session() {
	while true; do
		tmux has
		if [[ $? == 1 ]]; then
			echo "No sessions created yet, please create one."
			create_new_session
			return
		else
			read -r SESSION_NAME
			case "$SESSION_NAME" in
			m) return ;;
			e) exit 0 ;;
			esac
			tmux attach -t "$SESSION_NAME"
			if [[ $? == 0 ]]; then
				return
			else
				echo "Session not found. Try again or [m] to return to menu, [e] to exit."
			fi
		fi
	done
}

create_new_session() {
	while true; do
		echo -e "\nCreate a new session — type a name, or [m] for main menu, [e] to exit:"
		read -r SESSION_NAME
		case "$SESSION_NAME" in
		m) return ;;
		e) exit 0 ;;
		esac

		if [[ -n "$TMUX" ]]; then
			tmux new-session -ds "$SESSION_NAME"
			tmux switch-client -t "$SESSION_NAME"
		else
			tmux new -s "$SESSION_NAME"
		fi
	done
}

kill_sessions() {
	while true; do
		local sessions current_session other_sessions session_to_switch
		sessions=($(tmux list-sessions -F '#{session_id}:#{session_name}'))
		current_session=$(tmux display-message -p '#S')

		if [[ ${#sessions[@]} -eq 0 ]]; then
			echo "No tmux sessions to kill."
			return
		fi

		echo -e "\nAvailable sessions:"
		for i in "${!sessions[@]}"; do
			name=$(echo "${sessions[$i]}" | cut -d':' -f2)
			echo "[$i] $name"
		done

		echo -e "\nType session number(s) or name(s) to kill, or [m] for main menu, [e] to exit:"
		read -a selections

		# Handle menu/exit directly
		if [[ "${selections[0]}" == "m" ]]; then return; fi
		if [[ "${selections[0]}" == "e" ]]; then exit 0; fi

		sessions_to_kill=()
		for selection in "${selections[@]}"; do
			if [[ "$selection" =~ ^[0-9]+$ ]] && [[ -n "${sessions[$selection]}" ]]; then
				sessions_to_kill+=("$(echo "${sessions[$selection]}" | cut -d':' -f2)")
			else
				sessions_to_kill+=("$selection")
			fi
		done

		for session in "${sessions_to_kill[@]}"; do
			if tmux has-session -t "$session" 2>/dev/null; then
				if [[ "$session" == "$current_session" ]]; then
					other_sessions=($(tmux list-sessions -F '#S' | grep -v "^$session$"))
					if [[ ${#other_sessions[@]} -gt 0 ]]; then
						session_to_switch="${other_sessions[0]}"
						echo "Switching from current session '$current_session' to '$session_to_switch' before killing..."
						tmux switch-client -t "$session_to_switch"
					else
						echo "You're killing the only session. No others to switch to."
					fi
				fi
				tmux kill-session -t "$session" && echo "Killed session: $session"
			else
				echo "Session '$session' not found."
			fi
		done
	done
}

check_resurrect_usage() {
	TMUX_CONF="${HOME}/.tmux.conf"
	RESURRECT_DIRS=(
		"${HOME}/.local/share/tmux/resurrect"
		"${HOME}/.tmux/resurrect"
	)

	if grep -q "tmux-plugins/tmux-resurrect" "$TMUX_CONF"; then
		CUSTOM_DIR=$(grep -E "^set(-g)? +@resurrect-dir" "$TMUX_CONF" | awk '{print $3}' | tr -d "'\"")
		[[ -n "$CUSTOM_DIR" ]] && RESURRECT_DIRS+=("$CUSTOM_DIR")

		for dir in "${RESURRECT_DIRS[@]}"; do
			if [[ -f "$dir/last" ]]; then
				echo "Detected tmux-resurrect with a 'last' session saved. Restoring..."
				tmux new-session -d -s resurrect_restore_session
				tmux send-keys -t resurrect_restore_session C-b C-r
				tmux attach-session -t resurrect_restore_session
				return
			fi
		done

		echo "tmux-resurrect detected but no 'last' session found. You might want to create a session."
	else
		echo "tmux-resurrect not detected in .tmux.conf."
	fi

	while true; do
		echo -e "\n[m] Main menu | [e] Exit | [Enter] Do nothing again"
		read -r choice
		case "$choice" in
		m) return ;;
		e) exit 0 ;;
		*) ;;
		esac
	done
}

main_menu() {
	while :; do
		echo -e "\nPlease choose: 
c - Create a new session
a - Attach to an existing one
k - Kill one or more sessions
n - Do nothing (using tmux-resurrect)
e - Do not use tmux
"
		read -r OPTION
		case ${OPTION} in
		c)
			clear
			create_new_session
			;;
		a)
			clear
			return_opened_sessions_names
			attach_session
			;;
		k)
			clear
			kill_sessions
			;;
		n)
			clear
			check_resurrect_usage
			;;
		e)
			exec $SHELL -l
			;;
		*)
			clear
			zsh || bash
			;;
		esac
	done
}

main_menu
