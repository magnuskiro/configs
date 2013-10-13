# ln -s ~/configs/.profile ~/.profile

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# extra path variables for development and such.
export JAVA_HOME=/usr/lib/jvm/jdk1.7.0
export JDK_HOME=/usr/lib/jvm/jdk1.7.0/bin
export M2_HOME=/usr/local/apache-maven/apache-maven-3.0.4
export M2=$M2_HOME/bin
export IDEA=/usr/local/idea/bin
export PYCHARM=/usr/local/pycharm/bin

export PATH=$PATH:$M2_HOME:$M2:$JAVA_HOME:$JDK_HOME:$IDEA:$PYCHARM

