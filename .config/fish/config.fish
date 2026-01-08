if status is-interactive
    # Commands to run in interactive sessions can go here
    # set global editor to NVIM
    set -gx EDITOR nvim

    # aliases
    alias vim=nvim
    alias open=xdg-open
    # alias pycharm=pycharm-professional
    alias xclip="xclip -selection clipboard"
    alias pk="pokemon-colorscripts -s -r --no-title"
    alias pkb="pokemon-colorscripts -s -b -r --no-title"
    alias chrome="google-chrome-stable"
    alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

    # initialize environments
    #status --is-interactive; and ~/.rbenv/bin/rbenv init - fish | source

    set -g -x GMAIL_APP_USER 'first.object.oriented@gmail.com'
    set -g -x GMAIL_APP_PW xnnyalrrkjazhmbl

    #set -gx PATH /usr/pgsql-12/bin $PATH
    set -gx PATH /opt/pycharm-2025.3.1//bin $PATH
    set -gx PATH /home/kevin/.local/bin $PATH
    # vim binding
    # fish_vi_key_bindings
    fzf --fish | source

    if status is-interactive
        if set -q TERMINAL_EMULATOR; and test "$TERMINAL_EMULATOR" = JetBrains-JediTerm
            set -gx STARSHIP_CONFIG /dev/null
        end
    end
    starship init fish | source
    zoxide init fish | source
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
        pokemon-colorscripts -r -s -b --no-title
    end

    cat ~/.cache/wal/sequences
end
alias fixpad="sudo /usr/local/sbin/fix-syna32e2.sh"
