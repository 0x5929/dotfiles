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
    starship init fish | source
    fish_default_key_bindings


    function bind_bang
        switch (commandline -t)[-1]
            case "!"
                commandline -t -- $history[1]
                commandline -f repaint
            case "*"
                commandline -i !
        end
    end

    function bind_dollar
        switch (commandline -t)[-1]
            case "!"
                commandline -f backward-delete-char history-token-search-backward
            case "*"
                commandline -i '$'
        end
    end

    function fish_user_key_bindings
        bind ! bind_bang
        bind '$' bind_dollar
    end
    function fish_greeting
      pokemon-colorscripts -r -s
    end

    cat ~/.cache/wal/sequences
end
