- [Usage:](#usage)
  - [Clone](#clone)
  - [Terminals configuration](#terminals-configuration)
    - [Terminator](#terminator)
    - [gnome-terminal](#gnome-terminal)
    - [xterm](#xterm)
    - [Iterm2 configuration](#iterm2-configuration)
    - [vscode integrated terminal osx configuration](#vscode-integrated-terminal-osx-configuration)
  - [Description](#description)
  - [Example](#example)



# Usage: 

## Clone
`git clone https://github.com/abargiela/tmux_startup_session_selector.git ~/Documents/tmux_startup_session_selector`


## Terminals configuration

### Terminator 

right click inside the terminator click in `Preferences`

navigate through tab: `Profiles`

navigate through sub-tab: `Commands`

check the box: `Run a custom commmand instead of my shell`

In the field: `custom command:` add the path to the script  

### gnome-terminal 
right click inside the terminator click in `Preferences`

navigate through tab: `Commands`

check the box: `Run a custom commmand instead of my shell`

### xterm 

`xterm -e "~/Documents/tmux_startup_session_selector/tmux_startup_session_selector.sh"`

### Iterm2 configuration

In Preferences, go to: `Profiles -> General -> Command ` and choose: `login shell`

And add the path where this script is located: 

`bash ~/Documents/tmux_startup_session_selector/tmux_startup_session_selector.sh`

### vscode integrated terminal osx configuration

Press: `ctrl + shift + P` and write: `Preferences: Open Settings (JSON)` 

Here you have to add the full path, if you kept the suggested structure, just change `YOURUSER` to your username and it will work.

`"terminal.integrated.shellArgs.osx": ["/Users/YOURUSER/Documents/tmux_startup_session_selector/tmux_startup_session_selector.sh" ]`

If it doesn't work just restart vscode.


## Description

The main idea behind this script was to facilitate when I open a new terminal have an easy way to choose a new/existent/or skip a new session of tmux without type any command, so it's helpful for me, hope it can help you, suggestions are welcome.


## Example
![Alt Text](./iterm.gif)
