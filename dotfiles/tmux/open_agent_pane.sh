#!/bin/bash
set -euo pipefail

# Opens an AI agent pane on the right side of the current pane.
# tmux options (preferred):
# - @ai_default_agent: default agent command for "default" mode
# - @ai_pane_size: pane size passed to `split-window -l` (default: 60)
# - default mode: use @ai_default_agent if valid, otherwise show chooser
# - choose mode: always show chooser from detected agent CLIs
# - launch mode: open a pane with a specific agent command
if [[ -z "${TMUX:-}" ]]; then
  echo "This script must be run inside tmux." >&2
  exit 1
fi

# tmux run-shell は最小限の PATH になる場合があるため、
# ユーザー環境で CLI が入りやすいディレクトリを補完する。
add_path_if_dir() {
  local dir="$1"
  if [[ -d "${dir}" ]] && [[ ":${PATH}:" != *":${dir}:"* ]]; then
    PATH="${dir}:${PATH}"
  fi
}

add_path_if_dir "${HOME}/.local/bin"
add_path_if_dir "${HOME}/.cargo/bin"
add_path_if_dir "${HOME}/go/bin"
add_path_if_dir "/opt/homebrew/bin"
add_path_if_dir "/usr/local/bin"
export PATH

mode="${1:-default}"
agent_arg="${2:-}"
pane_size="60"
default_agent=""

agents=(
  "codex:codex"
  "claude:claude"
  "aider:aider"
  "gemini:gemini"
  "opencode:opencode"
  "copilot:copilot"
  "cursor:agent"
)

has_command() {
  command -v "$1" >/dev/null 2>&1
}

resolve_agent_command() {
  # ユーザー入力(表示名/実コマンド)を実行コマンドに正規化する。
  local selection="$1"
  local spec
  local name
  local command

  for spec in "${agents[@]}"; do
    IFS=':' read -r name command <<<"${spec}"
    if [[ "${selection}" == "${name}" ]] || [[ "${selection}" == "${command}" ]]; then
      printf '%s' "${command}"
      return 0
    fi
  done

  printf '%s' "${selection}"
}

resolve_agent_name() {
  # ユーザー入力(表示名/実コマンド)を表示名に正規化する。
  local selection="$1"
  local spec
  local name
  local command

  for spec in "${agents[@]}"; do
    IFS=':' read -r name command <<<"${spec}"
    if [[ "${selection}" == "${name}" ]] || [[ "${selection}" == "${command}" ]]; then
      printf '%s' "${name}"
      return 0
    fi
  done

  printf '%s' "${selection}"
}

tmux_option_value() {
  # 未設定オプションでもスクリプトを継続できるよう、失敗時は空文字扱いにする。
  local key="$1"
  tmux show-options -gqv "${key}" 2>/dev/null || true
}

trim_spaces() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "${s}"
}

# tmux option のみを参照する。
default_agent="$(tmux_option_value @ai_default_agent)"
pane_size="$(trim_spaces "$(tmux_option_value @ai_pane_size)")"

default_agent="$(trim_spaces "${default_agent}")"
pane_size="$(trim_spaces "${pane_size}")"

if [[ -z "${pane_size}" ]]; then
  pane_size="60"
fi

open_agent_pane() {
  # pane生成のみを行い、通知は各CLI側の機能へ委譲する。
  local selection="$1"
  local agent
  local display_name
  local pane_id

  agent="$(resolve_agent_command "${selection}")"
  display_name="$(resolve_agent_name "${selection}")"

  if ! has_command "${agent}"; then
    tmux display-message "Agent command not found: ${display_name} (${agent})"
    return 1
  fi

  pane_id="$(
    tmux split-window -d -P -F '#{pane_id}' -h -l "${pane_size}" -c "#{pane_current_path}" "${agent}"
  )"

  tmux set-option -p -t "${pane_id}" @ai_agent_pane "1" >/dev/null
  tmux select-pane -t "${pane_id}"
}

show_menu() {
  # 実行可能なエージェントだけを列挙してメニュー表示する。
  local available_specs=()
  local available_names=()
  local key
  local idx=0
  local menu_args=()
  local spec
  local name
  local command
  local default_name
  local default_command

  for spec in "${agents[@]}"; do
    IFS=':' read -r name command <<<"${spec}"
    if has_command "${command}"; then
      available_specs+=("${name}:${command}")
      available_names+=("${name}")
    fi
  done

  # デフォルトが主要候補外でも、コマンドが存在すれば選択肢に加える
  if [[ -n "${default_agent}" ]]; then
    default_name="$(resolve_agent_name "${default_agent}")"
    default_command="$(resolve_agent_command "${default_agent}")"

    if has_command "${default_command}"; then
      case " ${available_names[*]} " in
        *" ${default_name} "*) ;;
        *)
          available_specs=("${default_name}:${default_command}" "${available_specs[@]}")
          available_names=("${default_name}" "${available_names[@]}")
          ;;
      esac
    fi
  fi

  if [[ "${#available_specs[@]}" -eq 0 ]]; then
    tmux display-message "No supported AI agent CLI found"
    return 1
  fi

  if ! tmux list-commands 2>/dev/null | grep -q '^display-menu'; then
    tmux display-message "display-menu is unavailable on this tmux version"
    return 1
  fi

  for spec in "${available_specs[@]}"; do
    IFS=':' read -r name command <<<"${spec}"
    idx=$((idx + 1))
    if [[ "${idx}" -le 9 ]]; then
      key="${idx}"
    else
      key=""
    fi

    menu_args+=("${name}" "${key}" "run-shell '~/.config/tmux/open_agent_pane.sh launch ${name}'")
  done

  menu_args+=("" "" "")
  menu_args+=("Cancel" "q" "")

  tmux display-menu -T "AI Agent" -x P -y P "${menu_args[@]}"
}

case "${mode}" in
  default)
    if [[ -n "${default_agent}" ]] && has_command "$(resolve_agent_command "${default_agent}")"; then
      open_agent_pane "${default_agent}"
    else
      show_menu
    fi
    ;;
  choose)
    show_menu
    ;;
  launch)
    if [[ -z "${agent_arg}" ]]; then
      tmux display-message "Usage: open_agent_pane.sh launch <agent>"
      exit 1
    fi
    open_agent_pane "${agent_arg}"
    ;;
  *)
    tmux display-message "Usage: open_agent_pane.sh [default|choose|launch <agent>]"
    exit 1
    ;;
esac
