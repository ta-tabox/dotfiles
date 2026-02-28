# tmux上のzsh全ペインで設定を再読み込みする
# Usage: tmux_reload_zsh_all_panes_conf [CONFIG_PATH]
#        tmux_reload_zsh_all_panes_conf -h|--help
#        tmux_reload_zsh_all_panes_conf --tmux-help
tmux_reload_zsh_all_panes_conf() {
  local script_path="$HOME/.config/tmux/reload_shell_conf.sh"

  case "${1:-}" in
    -h|--help)
      cat <<'EOF_HELP'
Usage:
  tmux_reload_zsh_all_panes_conf [CONFIG_PATH]

Description:
  tmux上の全ペインを対象に、current_command が zsh のペインへ
  zsh設定の source を送信します。

Arguments:
  CONFIG_PATH   再読み込みする設定ファイル（省略時: ~/.zshrc）

Options:
  -h, --help    このヘルプを表示
  --tmux-help   内部で呼び出すtmuxスクリプトのヘルプを表示
EOF_HELP
      return 0
      ;;
    --tmux-help)
      "${script_path}" -h
      return $?
      ;;
  esac

  local config_path="${1:-~/.zshrc}"
  "${script_path}" zsh "${config_path}"
}
