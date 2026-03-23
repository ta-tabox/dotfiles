#!/usr/bin/env bash
set -euo pipefail

# ユーザー通知の共通エントリポイント。
# 優先順:
# 1) tmux status line message
# 2) 効果音 (afplay / bell)
# 3) macOS通知 (terminal-notifier 優先、なければ osascript)
# 4) ログ出力
#
# sender 指定は通常不要。
# terminal-notifier を使う場合は、TERM_PROGRAM から bundle identifier を推定する。
# 明示指定したい場合だけ NOTIFY_SENDER / TMUX_NOTIFY_SENDER に bundle identifier
# (例: org.alacritty, com.mitchellh.ghostty) を入れる。

title="${1:-TMUX Notification}"
body="${2:-Event detected}"
subtitle="${3:-tmux}"
log_file="${HOME}/.cache/tmux-notify.log"
fallback_log_file="/tmp/tmux-notify.log"
tmp_err="$(mktemp /tmp/tmux-notify.XXXXXX 2>/dev/null || true)"
if [[ -z "${tmp_err}" ]]; then
  tmp_err="/dev/null"
fi
resolved_sender=""
sender_source=""
force_osascript_fallback=0

# 一時ファイルの後始末。
cleanup() {
  if [[ "${tmp_err}" != "/dev/null" ]] && [[ -f "${tmp_err}" ]]; then
    rm -f "${tmp_err}" 2>/dev/null || true
  fi
}
trap cleanup EXIT

delivered=0

# AppleScript文字列に埋め込めるよう最小限のエスケープを行う。
escape_applescript_string() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/ }"
  printf '%s' "${s}"
}

log_notify() {
  # 通知失敗時の調査用ログを残す。
  local log_dir
  local line
  log_dir="$(dirname "${log_file}")"
  line="$(date '+%Y-%m-%d %H:%M:%S') $1"
  mkdir -p "${log_dir}" >/dev/null 2>&1 || true
  if [[ -w "${log_dir}" ]]; then
    printf '%s\n' "${line}" >>"${log_file}" 2>/dev/null || true
    return
  fi
  if [[ -w "$(dirname "${fallback_log_file}")" ]]; then
    printf '%s\n' "${line}" >>"${fallback_log_file}" 2>/dev/null || true
  fi
}

resolve_sender() {
  # 通知 sender と、その解決元を返す（"sender<TAB>source"）。
  # source は env / term:* / default。
  local sender="${TMUX_NOTIFY_SENDER:-${NOTIFY_SENDER:-}}"
  if [[ -n "${sender}" ]]; then
    printf '%s\tenv\n' "${sender}"
    return 0
  fi

  case "${TERM_PROGRAM:-}" in
    Alacritty)
      printf 'org.alacritty\tterm:Alacritty\n'
      return 0
      ;;
    Apple_Terminal)
      printf 'com.apple.Terminal\tterm:Apple_Terminal\n'
      return 0
      ;;
    iTerm.app|iTerm2|iTerm)
      printf 'com.googlecode.iterm2\tterm:iTerm\n'
      return 0
      ;;
    WezTerm|wezterm)
      printf 'org.wezfurlong.wezterm\tterm:WezTerm\n'
      return 0
    ;;
    ghostty|Ghostty)
      printf 'com.mitchellh.ghostty\tterm:Ghostty\n'
      return 0
      ;;
    kitty)
      printf 'org.kittylinux.kitty\tterm:kitty\n'
      return 0
      ;;
  esac

  printf 'com.apple.Terminal\tdefault\n'
  return 0
}

run_terminal_notifier_notification() {
  local escaped_title="$1"
  local escaped_body="$2"
  local escaped_subtitle="$3"
  local sender="$4"

  if [[ -n "${sender}" ]] && terminal-notifier -sender "${sender}" -title "${escaped_title}" -subtitle "${escaped_subtitle}" -message "${escaped_body}" >/dev/null 2>"${tmp_err}"; then
    log_notify "mac notify success: terminal-notifier (sender=${sender})"
    return 0
  fi

  if terminal-notifier -title "${escaped_title}" -subtitle "${escaped_subtitle}" -message "${escaped_body}" >/dev/null 2>"${tmp_err}"; then
    log_notify "mac notify success: terminal-notifier"
    return 0
  fi

  if [[ "${tmp_err}" != "/dev/null" ]] && [[ -r "${tmp_err}" ]]; then
    log_notify "terminal-notifier failed: $(tr '\n' ' ' <"${tmp_err}")"
  else
    log_notify "terminal-notifier failed"
  fi
  return 1
}

run_osascript_notification() {
  local escaped_title="$1"
  local escaped_body="$2"
  local escaped_subtitle="$3"

  if osascript -e "display notification \"${escaped_body}\" with title \"${escaped_title}\" subtitle \"${escaped_subtitle}\"" >/dev/null 2>"${tmp_err}"; then
    log_notify "mac notify success: osascript"
    return 0
  fi

  if command -v launchctl >/dev/null 2>&1; then
    if launchctl asuser "$(id -u)" osascript -e "display notification \"${escaped_body}\" with title \"${escaped_title}\" subtitle \"${escaped_subtitle}\"" >/dev/null 2>"${tmp_err}"; then
      log_notify "mac notify success: launchctl asuser osascript"
      return 0
    fi
  fi

  if [[ "${tmp_err}" != "/dev/null" ]] && [[ -r "${tmp_err}" ]]; then
    log_notify "osascript failed: $(tr '\n' ' ' <"${tmp_err}")"
  else
    log_notify "osascript failed"
  fi
  return 1
}

if [[ -n "${TMUX:-}" ]] && command -v tmux >/dev/null 2>&1; then
  # GUI通知と独立して tmux 内にもイベントを表示する。
  tmux display-message "${body}" || true
else
  log_notify "tmux notification unavailable in current context"
fi

# 聴覚通知を先に出し、視覚通知失敗時も気づけるようにする。
if command -v afplay >/dev/null 2>&1; then
  sound_file="/System/Library/Sounds/Glass.aiff"
  if [[ -f "${sound_file}" ]]; then
    afplay "${sound_file}" >/dev/null 2>&1 &
  else
    printf '\a'
  fi
else
  printf '\a'
fi

read -r resolved_sender sender_source < <(resolve_sender)
if [[ "${sender_source}" == "default" || "${resolved_sender}" == "com.apple.Terminal" ]]; then
  if (( force_osascript_fallback == 1 )); then
    force_osascript_fallback=0
  fi
fi
if [[ "${resolved_sender}" != "com.apple.Terminal" ]] && [[ "${sender_source}" != "default" ]]; then
  # 非既定 sender は terminal-notifier で抑止されやすいため osascript を追加実行。
  force_osascript_fallback=1
fi

if ! command -v terminal-notifier >/dev/null 2>&1; then
  # terminal-notifier がない場合は osascript で代替。
  log_notify "terminal-notifier unavailable"
else
  log_notify "notification sender resolved: ${resolved_sender} (source=${sender_source}, fallback=${force_osascript_fallback})"
  # Focus との相性が良いことが多い terminal-notifier を先行実行
  if run_terminal_notifier_notification "${title}" "${body}" "${subtitle}" "${resolved_sender}"; then
    delivered=1
  fi
fi

if (( delivered == 0 || force_osascript_fallback == 1 )) && command -v osascript >/dev/null 2>&1; then
  # terminal-notifier が失敗した場合は osascript で最終フォールバック
  escaped_title="$(escape_applescript_string "${title}")"
  escaped_body="$(escape_applescript_string "${body}")"
  escaped_subtitle="$(escape_applescript_string "${subtitle}")"
  if run_osascript_notification "${escaped_title}" "${escaped_body}" "${escaped_subtitle}"; then
    delivered=1
  fi
fi

if (( delivered == 0 )); then
  log_notify "notification fallback result: no delivery path succeeded title='${title}' subtitle='${subtitle}'"
  exit 1
fi

log_notify "notification delivered by at least one path: title='${title}' subtitle='${subtitle}'"
