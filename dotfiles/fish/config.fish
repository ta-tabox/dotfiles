# load local variables
if test -f ~/.config/fish/.local
    source ~/.config/fish/.local
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

# Initialize plugins
anyenv init - fish | source
zoxide init fish | source
fzf --fish | source
export FZF_DEFAULT_COMMAND='fd --type f'
starship init fish | source
