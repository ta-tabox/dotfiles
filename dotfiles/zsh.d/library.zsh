# Initialize
eval "$(sheldon source)"

if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
elif command -v anyenv &> /dev/null; then
    eval "$(anyenv init - zsh)"
fi

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='fd --type f'

# lazygitの設定パスを変更
export XDG_CONFIG_HOME="$HOME/.config"
