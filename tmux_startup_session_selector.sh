#!/bin/bash

# Usage: Read the README.md

# This script was created with the purpose of make easier the use of tmux basics commands like create new sessions or attach to existent one, feel free to suggest improvemnts.

return_opened_sessions_names(){
    echo -e "
Currently opened sessions:
Type the name that you want to connect and press enter:
$(tmux list-sessions -F '#S')"
}

attach_session(){
    # check if there is any tmux session, if there isn't, it creates one.
    tmux has
    if [[ $?  == 1 ]]; then
        echo "No sessions created yet, please, create one"
        create_new_session
    # If already exists an active session, it shows you the active sessions for you choose.
    else
        read SESSION_NAME
        tmux attach -t $SESSION_NAME
        while [[ $? != 0 ]];do
            attach_session
        done
    fi
}

create_new_session(){
    # Function to create new session
    echo -e "
Creating a new session, type a name and hit enter."
    read SESSION_NAME
    tmux new -s $SESSION_NAME
}

echo -e "Please choose: 
c - Create a new session
a - Attach to an existent one
e - Do not use tmux
"

while :
do
  read OPTION
    case ${OPTION} in
    	c)
            clear
            create_new_session
            break
    		;;
    	a)
            clear
            return_opened_sessions_names
            attach_session
            break
    		;;
        e) 
            break
            ;;
        *) 
            # Used for vscode run integrated terminal
            clear
            zsh || bash
            ;;
    esac
done
