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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/kevin/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/kevin/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/kevin/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/kevin/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/kevin/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/home/kevin/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/kevin/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/home/kevin/Downloads/google-cloud-sdk/completion.bash.inc'; fi
