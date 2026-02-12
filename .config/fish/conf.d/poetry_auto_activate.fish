function __poetry_project_root
    set -l dir $PWD
    while true
        if test -f "$dir/pyproject.toml"
            echo $dir
            return 0
        end
        if test "$dir" = /
            return 1
        end
        set dir (path dirname -- $dir)
    end
end

function __poetry_activate_for_root --argument-names root
    command -q poetry; or return 1

    set -l venv (poetry -C "$root" env info -p 2>/dev/null)
    test -n "$venv"; or return 1
    test -f "$venv/bin/activate.fish"; or return 1

    # If already in this exact venv, do nothing
    if set -q VIRTUAL_ENV; and test "$VIRTUAL_ENV" = "$venv"
        return 0
    end

    # If we are in some other venv (e.g. previous project), deactivate first
    if set -q VIRTUAL_ENV
        type -q deactivate; and deactivate
    end

    source "$venv/bin/activate.fish"
    return 0
end

function __poetry_auto_venv
    status is-interactive; or return

    set -l root (__poetry_project_root)
    if test $status -eq 0
        __poetry_activate_for_root "$root"
        return
    end

    # Not inside a poetry project: if we previously auto-activated, deactivate.
    if set -q VIRTUAL_ENV
        type -q deactivate; and deactivate
    end
end

# Trigger on directory changes
function __poetry_auto_venv_on_pwd --on-variable PWD
    __poetry_auto_venv
end

# Run once at shell start (covers "start fish already in repo")
function __poetry_auto_venv_once --on-event fish_prompt
    functions -e __poetry_auto_venv_once
    __poetry_auto_venv
end
