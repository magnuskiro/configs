#!/bin/sh
: <<'END'
Append 
"source ./aliases.bashrc"
to ./.bashrc
END

# Aliases
alias h="history"
alias l="ls -lAhoF --color --show-control-chars"
alias cd..="cd .."

# ack-grep. Does the same as grep, only better.
alias a="ack-grep --color"

## TP x201 specifics
# dockingStation
alias dock="~/repos/scripts/dockingStation.sh"

# fortune - LMDE specific. 
/usr/games/fortune -s

# compilescript 
alias compile="~/repos/scripts/compile.sh"

# IRC, irssi screens. 
alias ircsrv="screen -RD -S irc irssi"
alias irc="ssh kiro@s.magnuskiro.no -p 40596 -t 'screen -RD -S irc irssi'"
