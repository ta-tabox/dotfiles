#!/bin/bash
set -euo pipefail

print_help() {
  cat <<'EOF'
Usage:
  reload_shell_conf.sh <shell_name> <config_path>

Description:
  tmuxの全ペインを走査し、current_command が <shell_name> のペインに
  `source <config_path>` を送信します。
  実行元ペインは current_command が一致しない場合でも、コマンド完了後に
  source が実行されるようにキュー投入します。
  `open_agent_pane.sh` で開いたAIエージェント用ペインは対象外です。

Options:
  -h, --help    このヘルプを表示
EOF
}

# ヘルプオプション
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  print_help
  exit 0
fi

# tmux外で実行しても対象ペインを特定できないため終了する
if [[ -z "${TMUX:-}" ]]; then
  echo "This script must be run inside tmux." >&2
  exit 1
fi

# 引数は「対象シェル名」と「再読み込みする設定ファイルパス」の2つを必須とする
if [[ "$#" -ne 2 ]]; then
  echo "Usage: $0 <shell_name> <config_path>" >&2
  echo "Use '$0 -h' for help." >&2
  exit 1
fi

shell_name="$1"
config_path_input="$2"

if [[ ! "${shell_name}" =~ ^[a-zA-Z0-9._+-]+$ ]]; then
  echo "Invalid shell name: ${shell_name}" >&2
  exit 1
fi

# "~" から始まるパスを $HOME に展開して扱う
if [[ "${config_path_input}" == ~* ]]; then
  config_path="${HOME}${config_path_input#\~}"
else
  config_path="${config_path_input}"
fi

# shell_name と無関係な設定ファイル誤指定を避けるため、パス文字列に shell 名を要求する
if [[ "${config_path}" != *"${shell_name}"* ]]; then
  echo "Invalid config path for ${shell_name}: ${config_path_input}" >&2
  echo "Path must include shell name '${shell_name}'." >&2
  exit 1
fi

# 設定ファイルとして妥当か（存在・通常ファイル・可読）を事前に検証する
if [[ ! -e "${config_path}" ]]; then
  echo "Config path does not exist: ${config_path}" >&2
  exit 1
fi

if [[ ! -f "${config_path}" ]]; then
  echo "Config path is not a regular file: ${config_path}" >&2
  exit 1
fi

if [[ ! -r "${config_path}" ]]; then
  echo "Config file is not readable: ${config_path}" >&2
  exit 1
fi

# 全セッション/全ウィンドウのペインを列挙し、現在動作中コマンドと
# AIエージェント用ペインの印を取得する。
# tmux format の `\t` はタブ展開されないため、Bash 側で実タブを埋め込む。
pane_format=$'#{pane_id}\t#{pane_current_command}\t#{@ai_agent_pane}'
pane_lines="$(tmux list-panes -a -F "${pane_format}")"
if [[ -z "${pane_lines}" ]]; then
  echo "No tmux panes found."
  exit 0
fi

# パスに空白等が含まれても send-keys で安全に扱えるようにエスケープする
escaped_config="$(printf '%q' "${config_path}")"
reload_cmd="source ${escaped_config}"

reloaded=0
skipped=0
queued_current_pane=0
current_pane_id="${TMUX_PANE:-}"
skipped_details=""

# current_command が対象シェルのペインだけに source を送信する
# vim など他プロセスが前面のペインはここで自動的にスキップされる
while IFS=$'\t' read -r pane_id pane_cmd is_ai_agent_pane; do
  if [[ "${is_ai_agent_pane:-0}" == "1" ]]; then
    pane_cmd="${pane_cmd:-unknown}"
    skipped_details+="- ${pane_id}: ${pane_cmd} (ai-agent)"$'\n'
    skipped=$((skipped + 1))
  elif [[ "${pane_cmd}" == "${shell_name}" ]]; then
    tmux send-keys -t "${pane_id}" "${reload_cmd}" C-m
    reloaded=$((reloaded + 1))
  # 実行元ペインは、スクリプト実行中に current_command が bash になりやすい。
  # その場合も source をキー入力として先行送信しておき、コマンド完了後に反映させる。
  elif [[ -n "${current_pane_id}" && "${pane_id}" == "${current_pane_id}" ]]; then
    tmux send-keys -t "${pane_id}" "${reload_cmd}" C-m
    queued_current_pane=$((queued_current_pane + 1))
  else
    pane_cmd="${pane_cmd:-unknown}"
    skipped_details+="- ${pane_id}: ${pane_cmd}"$'\n'
    skipped=$((skipped + 1))
  fi
done <<< "${pane_lines}"

total_panes=$((reloaded + queued_current_pane + skipped))
applied_panes=$((reloaded + queued_current_pane))
progress_hundredths=0
if [[ "${total_panes}" -gt 0 ]]; then
  progress_hundredths=$((applied_panes * 10000 / total_panes))
fi
progress_whole=$((progress_hundredths / 100))
progress_frac=$((progress_hundredths % 100))

echo "Shell: ${shell_name}"
echo "Config: ${config_path}"
echo "Reloaded ${reloaded} pane(s)."
echo "Queued for current pane ${queued_current_pane} pane(s)."
echo "Skipped ${skipped} pane(s)."
printf 'Progress: %d/%d ( %d.%02d%% )\n' \
  "${applied_panes}" "${total_panes}" "${progress_whole}" "${progress_frac}"

if [[ "${skipped}" -gt 0 ]]; then
  echo "Skipped pane commands:"
  printf "%s" "${skipped_details}"
fi
