#!/bin/sh

# Aliases
alias h="history"
alias l="ls -lAhoF --color --show-control-chars"
alias ll="ls -lash --color --show-control-chars"
alias cd..="cd .."


alias brew="/home/linuxbrew/.linuxbrew/bin/brew"

# ack-grep. Does the same as grep, only better.
alias a="ack --color"

# calculator
alias calc="gnome-calculator"

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
alias reload_bashhrc="source $HOME/.bashrc"
alias reload_profile="source $HOME/.profile"

# screen lock
alias xl="xscreensaver-command -lock"

# alias for perl whitespace fixup. 
alias perl-ws-fix="$HOME/repos/scripts/perl-ws-fix.sh"

alias postman=/usr/local/share/Postman/app/Postman

git_log_line (){
    git log -L$2,$3:$1
}
alias gll=git_log_line

#### Docker aliases.
# Kill all running containers.
alias dockerkillall='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all stopped containers and untagged images.
alias dockerclean='dockercleanc || true && dockercleani'
####

# Apace Maven
alias mci="mvn clean install"
alias mcist="mvn clean install -Dmaven.test.skip=true"

# intelliJ idea
alias idea="idea.sh"

alias k=kubectl
complete -F __start_kubectl k
