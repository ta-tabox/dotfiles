# load local variables
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end

# fishを直接起動した時にhomebrewの環境変数を設定する
if test -x /opt/homebrew/bin/brew
   eval (/opt/homebrew/bin/brew shellenv)
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/miniconda3/bin/conda
    eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/opt/miniconda3/etc/fish/conf.d/conda.fish"
        . "/opt/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/opt/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

# スタート時のメッセージを空に
set -U fish_greeting

# lazygitの設定ファイルのパスを~/.configに変更
set -gx XDG_CONFIG_HOME "$HOME/.config"

# Initialize plugins
# anyenv init - fish | source
mise activate fish | source
zoxide init fish | source
fzf --fish | source
starship init fish | source

# pnpm global bin
# miseでpnpmを管理するため、pnpm setupは使用せず、独自にpnpmのグローバルbinのパスを設定する
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not contains $PNPM_HOME $PATH
    set -gx PATH $PNPM_HOME $PATH
end

