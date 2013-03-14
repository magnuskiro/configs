#!/bin/sh
: <<'END'

Append 
"source ~/repos/configs/aliases.bashrc"
to /etc/bash.bashrc

END

# Aliases
alias h="history"
alias l='ls -lashF --color --show-control-chars'
alias cd..="cd .."

# git aliases 
alias gits="git status"
#alias gitc="git commit -am '"$_"'" 
alias gitc="git commit -am" 

# ack-grep
alias a="ack-grep --color"

# xfce4-display
alias x="xfce4-display-settings"

# fortune 
/usr/games/fortune
