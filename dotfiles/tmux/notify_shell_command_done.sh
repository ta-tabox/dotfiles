#!/usr/bin/env bash
set -euo pipefail

# シェルの長時間コマンド完了イベント専用。
# 通知文言を組み立てて、実際の配送は send_user_notification.sh に委譲する。

elapsed_seconds="${1:-0}"
exit_status="${2:-0}"
command_line="${3:-}"

extract_process_name() {
  local raw="$1"
  local token
  local tokens=()

  raw="${raw#"${raw%%[![:space:]]*}"}"
  raw="${raw%"${raw##*[![:space:]]}"}"

  if [[ -z "${raw}" ]]; then
    printf 'command'
    return
  fi

  # shellcheck disable=SC2206
  tokens=(${raw})
  for token in "${tokens[@]}"; do
    case "${token}" in
      [A-Za-z_][A-Za-z0-9_]*=*)
        continue
        ;;
      sudo|env|command|builtin|nocorrect|noglob|time|nohup)
        continue
        ;;
      --)
        continue
        ;;
      -*)
        continue
        ;;
      *)
        token="${token##*/}"
        printf '%s' "${token}"
        return
        ;;
    esac
  done

  printf 'command'
}

process_name="$(extract_process_name "${command_line}")"

if [[ "${exit_status}" -eq 0 ]]; then
  title="Command finished"
  body="${process_name} completed in ${elapsed_seconds}s"
else
  title="Command failed"
  body="${process_name} exited ${exit_status} after ${elapsed_seconds}s"
fi

if [[ -x "${HOME}/.config/tmux/send_user_notification.sh" ]]; then
  "${HOME}/.config/tmux/send_user_notification.sh" "${title}" "${body}" "${process_name}" >/dev/null 2>&1 || true
  exit 0
fi

exit 0
