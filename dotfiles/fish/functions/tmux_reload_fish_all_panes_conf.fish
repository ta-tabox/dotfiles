function tmux_reload_fish_all_panes_conf --description 'tmux上のfish全ペインで設定を再読み込み'
    set -l script_path ~/.config/tmux/reload_shell_conf.sh

    switch "$argv[1]"
        case -h --help
            echo 'Usage:'
            echo '  tmux_reload_fish_all_panes_conf [CONFIG_PATH]'
            echo ''
            echo 'Description:'
            echo '  tmux上の全ペインを対象に、current_command が fish のペインへ'
            echo '  fish設定の source を送信します。'
            echo ''
            echo 'Arguments:'
            echo '  CONFIG_PATH   再読み込みする設定ファイル（省略時: ~/.config/fish/config.fish）'
            echo ''
            echo 'Options:'
            echo '  -h, --help    このヘルプを表示'
            echo '  --tmux-help   内部で呼び出すtmuxスクリプトのヘルプを表示'
            return 0
        case --tmux-help
            "$script_path" -h
            return $status
    end

    set -l config_path ~/.config/fish/config.fish
    if test (count $argv) -ge 1
        set config_path $argv[1]
    end

    "$script_path" fish "$config_path"
end
