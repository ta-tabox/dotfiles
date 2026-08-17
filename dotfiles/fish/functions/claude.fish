# ~/.config/fish/functions/claude.fish
function claude --description 'Claude Code を共有設定レイヤー付きで起動する'
    set -l shared "$DOTFILES_ROOT/claude/settings.shared.json"
    if test -n "$DOTFILES_ROOT"; and test -f "$shared"
        command claude --settings "$shared" $argv
    else
        command claude $argv
    end
end
