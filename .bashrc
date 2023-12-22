# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific environment and startup programs

# added bin paths 
PATH="/usr/share/Modules/bin:/usr/local/cuda-11.1/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/opt/bin:/opt/script:$HOME/bin:$HOME/.local/bin" ; export PATH

# User specific aliases and functions
if [ -f $HOME/.bash_aliases ]; then
	. $HOME/.bash_aliases
fi

# setting default editor
export VISUAL=vim
export EDITOR="$VISUAL"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"
