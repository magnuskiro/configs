#!/bin/sh
: <<'END'
Append 
"source ./aliases.bashrc"
to ./.bashrc
END

# Aliases
alias h="history"
alias l='ls -lashF --color --show-control-chars'
alias cd..="cd .."

# ack-grep
alias a="ack-grep --color"

## TP x201 specifics
# dockingStation
alias dock="~/repos/scripts/dockingStation.sh"
# xfce4-display - TODO moce to dockingStation.sh to fix screens. 
alias x="xfce4-display-settings"

# fortune - LMDE specific. 
/usr/games/fortune

# compilescript 
alias compile="~/repos/scripts/compile.sh"
alias simplecompile="~/repos/scripts/simplecompile.sh"
alias ircsrv="screen -RD -S irc irssi"
