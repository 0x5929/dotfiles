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

    # vim binding
    # fish_vi_key_bindings
    fish_default_key_bindings

    # init pyenv
    pyenv init - | source
end
