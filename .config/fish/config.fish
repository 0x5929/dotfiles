if status is-interactive
    # Commands to run in interactive sessions can go here
    # set global editor to NVIM
    set -gx EDITOR nvim
  
    # aliases
    alias vim=nvim
    alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

    # initialize environments
    #status --is-interactive; and ~/.rbenv/bin/rbenv init - fish | source

    # export environment variables
    set -g -x POSTGRES_DATABASE_USERNAME kevin
    set -g -x POSTGRES_DATABASE_PASSWORD jordan45
    set -g -x GMAIL_APP_USER 'first.object.oriented@gmail.com'
    set -g -x GMAIL_APP_PW xnnyalrrkjazhmbl

    set -gx PATH /usr/pgsql-12/bin $PATH
    set -gx PATH /opt/nvim-linux64/bin $PATH
    set -gx PATH /usr/local/go/bin $PATH
    set -gx LD_LIBRARY_PATH /lib64 $LD_LIBRARY_PATH
    # vim binding
    # fish_vi_key_bindings
    fish_default_key_bindings

    # init pyenv
    # pyenv init - | source
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/kevin/miniconda3/bin/conda
    eval /home/kevin/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/kevin/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/kevin/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/kevin/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

