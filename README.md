- [Usage:](#usage)
  - [iterm2:](#iterm2)
  - [vscode integrated terminal osx](#vscode-integrated-terminal-osx)
  - [Description](#description)
  - [Example](#example)


# Usage: 

## iterm2:

In `Profiles -> General -> Command ` 

choose: `login shell` and add the path where this script is: `bash /path/to/script/tmux_startup_session_selector.sh`

## vscode integrated terminal osx

Open `setting.json` and add: 
`"terminal.integrated.shellArgs.osx": ["/path/to/script/tmux_startup_session_selector.sh" ]`


## Description

The main idea behind this script was to facilitate when I open a new terminal, so I have an easy way to choose a new or an existent session of tmux without type commands, so it's helpful for me, hope it can help you, suggestions are welcome.


## Example
![Alt Text](./iterm.gif)