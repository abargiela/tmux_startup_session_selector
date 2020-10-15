#!/bin/bash

# Usage: In `Profiles -> General -> Command ` choose: `login shell` and add the path where this script is: `bash ~/tmux_startup_session_selector.sh`

#In vscode: Open setting.json and add: 
#"terminal.integrated.shellArgs.osx": ["/path/to/script/tmux_startup_session_selector.sh" ]

#case $1 in
#    -e) bash &
#    ;;
#esac
return_opened_sessions_names(){
    echo -e "
Currently opened sessions:
Type the name that you want to connect and press enter:
$(tmux list-sessions -F '#S')"
}

attach_session(){
    tmux has
    if [[ $?  == 1 ]]; then
        echo "No sessions created yet, please, create one"
        create_new_session
    else
        read SESSION_NAME
        tmux attach -t $SESSION_NAME
        while [[ $? != 0 ]];do
            attach_session
        done
    fi
}

create_new_session(){
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
