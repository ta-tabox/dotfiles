if test -d "$HOME/.local/bin"
    if not contains "$HOME/.local/bin" $PATH
        set -gx PATH "$HOME/.local/bin" $PATH
    end
end

if test -n "$DOTFILES_ROOT"; and test -d "$DOTFILES_ROOT/bin/agent"
    if not contains "$DOTFILES_ROOT/bin/agent" $PATH
        set -gx PATH "$DOTFILES_ROOT/bin/agent" $PATH
    end
end
