#!/bin/sh
: <<'END'

Append 
"source ~/repos/configs/aliases.bashrc"
to /etc/bash.bashrc

echo "source ~/repos/configs/aliases.bashrc" >> ~/.bashrc

END

# append to bash rc.
# probably works for personal bash.bashrc files.  
#echo 'source ~/repos/configs/aliases.bashrc' >> /etc/bash.bashrc

# Aliases
alias h="history"
alias l='ls -lashF --color --show-control-chars'
alias cd..="cd .."

# ack-grep
alias a="ack-grep --color"

# xfce4-display
alias x="xfce4-display-settings"

# dockingStation
alias dock="~/repos/scripts/dockingStation.sh"

# fortune 
/usr/games/fortune
