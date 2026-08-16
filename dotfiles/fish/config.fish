# load local variables
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
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

# エディタのデフォルトをNeovimに統一
set -gx EDITOR nvim
set -gx VISUAL nvim

# lazygitの設定ファイルのパスを~/.configに変更
set -gx XDG_CONFIG_HOME "$HOME/.config"

# Initialize plugins
if type -q mise
    mise activate fish | source
else if type -q anyenv
    anyenv init - fish | source
end

zoxide init fish | source
fzf --fish | source
starship init fish | source

