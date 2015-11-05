#!/bin/sh

# Aliases
alias h="history"
alias l="ls -lAhoF --color --show-control-chars"
alias ll="ls -lash --color --show-control-chars"
alias cd..="cd .."

# ack-grep. Does the same as grep, only better.
alias a="ack-grep --color"

## TP x201 specifics
# dockingStation
alias dock="~/repos/scripts/docking.sh"

# IRC, irssi screens. 
alias ircsrv="screen -RD -S irc irssi"
ircssh="ssh kiro@magnuskiro.no -p 40596 -t 'screen -RD -S irc irssi'"
alias ircterm="x-terminal-emulator -e \"$ircssh\""
alias ircssh="$ircssh"

# copy to clipboard.
alias toc="~/repos/scripts/toclip.sh"

# reloading bashrc
alias reload_basrc="source $HOME/.bashrc"
alias reload_profile="source $HOME/.profile"

# screen lock
alias xl="xscreensaver-command -lock"

# alias for perl whitespace fixup. 
alias perl-ws-fix="$HOME/repos/scripts/perl-ws-fix.sh"
