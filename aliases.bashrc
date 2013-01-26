#!/bin/sh
: <<'END'

Append 
"source /home/kiro/repos/configs/aliases.bashrc"
to /etc/bash.bashrc

END

# Aliases
alias h="history"
alias l="ls -lsah"
alias cd..="cd .."

# git aliases 
alias gits="git status"
#alias gitc="git commit -am '"$_"'" 
alias gitc="git commit -am" 

# ack-grep
alias a="ack-grep --color"

# fortune 
/usr/games/fortune
