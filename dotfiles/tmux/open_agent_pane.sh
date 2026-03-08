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
  codex
  claude
  aider
  gemini
  opencode
)

has_command() {
  command -v "$1" >/dev/null 2>&1
}

tmux_option_value() {
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
  local agent="$1"

  if ! has_command "${agent}"; then
    tmux display-message "Agent command not found: ${agent}"
    return 1
  fi

  tmux split-window -h -l "${pane_size}" -c "#{pane_current_path}" "${agent}"
}

show_menu() {
  local available=()
  local key
  local idx=0
  local menu_args=()
  local agent

  for agent in "${agents[@]}"; do
    if has_command "${agent}"; then
      available+=("${agent}")
    fi
  done

  # デフォルトが主要候補外でも、コマンドが存在すれば選択肢に加える
  if [[ -n "${default_agent}" ]] && has_command "${default_agent}"; then
    case " ${available[*]} " in
      *" ${default_agent} "*) ;;
      *) available=("${default_agent}" "${available[@]}") ;;
    esac
  fi

  if [[ "${#available[@]}" -eq 0 ]]; then
    tmux display-message "No supported AI agent CLI found (checked: ${agents[*]})"
    return 1
  fi

  if ! tmux list-commands 2>/dev/null | grep -q '^display-menu'; then
    tmux display-message "display-menu is unavailable on this tmux version"
    return 1
  fi

  for agent in "${available[@]}"; do
    idx=$((idx + 1))
    if [[ "${idx}" -le 9 ]]; then
      key="${idx}"
    else
      key=""
    fi

    menu_args+=("${agent}" "${key}" "run-shell '~/.config/tmux/open_agent_pane.sh launch ${agent}'")
  done

  menu_args+=("" "" "")
  menu_args+=("Cancel" "q" "")

  tmux display-menu -T "AI Agent" -x P -y P "${menu_args[@]}"
}

case "${mode}" in
  default)
    if [[ -n "${default_agent}" ]] && has_command "${default_agent}"; then
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
