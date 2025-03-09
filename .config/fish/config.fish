if status is-interactive
    # Commands to run in interactive sessions can go here
    # set global editor to NVIM
    set -gx EDITOR nvim
  
    # aliases
    alias vim=nvim
    alias dotfiles="/usr/bin/git --git-dir=$HOME/Repositories/personal/dotfiles --work-tree=$HOME"

    # initialize environments
    #status --is-interactive; and ~/.rbenv/bin/rbenv init - fish | source

    set -g -x GMAIL_APP_USER 'first.object.oriented@gmail.com'
    set -g -x GMAIL_APP_PW xnnyalrrkjazhmbl

    #set -gx PATH /usr/pgsql-12/bin $PATH
    #set -gx PATH /opt/nvim-linux64/bin $PATH
    # vim binding
    # fish_vi_key_bindings
    fish_default_key_bindings
end
