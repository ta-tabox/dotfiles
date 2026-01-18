# Initialize
eval "$(sheldon source)"

eval "$(anyenv init -)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='fd --type f'

# lazygitの設定パスを変更
export XDG_CONFIG_HOME="$HOME/.config"
