#
# This a customized /etc/profile file. It's used the same way as /etc/environment and bashrc in many cases.
# I removed it from /etc/ and added it to my git repo. 
# 
# !!! Remember to TAKE A BACKUP of the profile file before messing with it.  !!!
# 
# Use: 'ln -s /path/to/file /path/to/symlink' to create a symlink from /etc/profile to the designated profile file. 
# 'sudo ln -s /home/kiro/repos/configs/profile /etc/profile'
# possibly: 'sudo rm /etc/profile | ln -s /home/kiro/repos/configs/profile /etc/profile'
###

# /etc/profile: system-wide .profile file for the Bourne shell (sh(1))
# and Bourne compatible shells (bash(1), ksh(1), ash(1), ...).

: <<'END'

Current folders for Linux Mint Debian. 
The folders have to be changed for other distributions.

# for LMDE and global profiles. 
sudo rm /etc/profile & ln -s /home/kiro/repos/configs/profile profile

# for ubuntu/ubuntu server and local profiles. 
rm ~/.profile & ln -s ~/repos/configs/profile .profile

END

if [ "`id -u`" -eq 0 ]; then
  PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
else
  PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
fi
export PATH

if [ "$PS1" ]; then
  if [ "$BASH" ]; then
    # The file bash.bashrc already sets the default PS1.
    # PS1='\h:\w\$ '
    if [ -f /etc/bash.bashrc ]; then
      . /etc/bash.bashrc
    fi
  else
    if [ "`id -u`" -eq 0 ]; then
      PS1='# '
    else
      PS1='$ '
    fi
  fi
fi

# The default umask is now handled by pam_umask.
# See pam_umask(8) and /etc/login.defs.

if [ -d /etc/profile.d ]; then
  for i in /etc/profile.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

# extra path variables for development and such. 
export JAVA_HOME=/usr/lib/jvm/jdk1.7.0
export JDK_HOME=/usr/lib/jvm/jdk1.7.0/bin
export M2_HOME=/usr/local/apache-maven/apache-maven-3.0.4
export M2=$M2_HOME/bin
export IDEA=/usr/local/idea/bin

export PATH=$PATH:$M2_HOME:$M2:$JAVA_HOME:$JDK_HOME:$IDEA

