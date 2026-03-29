# 長時間コマンド完了時の通知
# - しきい値以上の実行時間
# - 除外コマンド以外
# のときに、音 / tmux / macOS 通知を送る

autoload -Uz add-zsh-hook

: "${COMMAND_DONE_NOTIFY_THRESHOLD:=15}"

__cmd_notify_ignore_file="${HOME}/.config/tmux/command_done_notify_ignore.list"

__cmd_notify_load_default_ignore() {
  local file="$1"
  local line
  local -a values

  if [[ ! -r "${file}" ]]; then
    return 1
  fi

  while IFS= read -r line || [[ -n "${line}" ]]; do
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "${line}" ]] && continue
    [[ "${line}" == \#* ]] && continue
    values+=("${line}")
  done < "${file}"

  if (( ${#values[@]} > 0 )); then
    COMMAND_DONE_NOTIFY_IGNORE=("${values[@]}")
    return 0
  fi

  return 1
}

typeset -ga COMMAND_DONE_NOTIFY_IGNORE
if (( ${#COMMAND_DONE_NOTIFY_IGNORE[@]} == 0 )); then
  __cmd_notify_load_default_ignore "${__cmd_notify_ignore_file}" >/dev/null 2>&1
fi

typeset -gi __cmd_notify_started_at=0
typeset -g __cmd_notify_last_cmd=''

__cmd_notify_extract_cmd() {
  local raw="$1"
  local -a words
  local -a cmd_words
  local seen_cmd=0
  local w

  raw="${raw#"${raw%%[![:space:]]*}"}"
  if [[ -z "${raw}" ]]; then
    return 1
  fi

  words=( ${(z)raw} )
  for w in "${words[@]}"; do
    case "${w}" in
      [A-Za-z_][A-Za-z0-9_]*=*) continue ;;
      sudo|env|command|builtin|nocorrect|noglob|time|nohup) continue ;;
      --) continue ;;
      -*)
        if (( ! seen_cmd )); then
          continue
        fi
        cmd_words+=("${w}")
        ;;
      *)
        if (( seen_cmd )); then
          cmd_words+=("${w}")
        else
          cmd_words+=("${w:t}")
          seen_cmd=1
        fi
        ;;
    esac
  done

  if (( ${#cmd_words[@]} == 0 )); then
    return 1
  fi

  printf '%s' "${(L)${(j: :)cmd_words}}"
}

__cmd_notify_should_skip() {
  local cmd="$1"
  local ignored

  for ignored in "${COMMAND_DONE_NOTIFY_IGNORE[@]}"; do
    ignored="${ignored:l}"
    if [[ "${cmd}" == "${ignored}" || "${cmd}" == "${ignored}"\ * ]]; then
      return 0
    fi
  done

  return 1
}

__cmd_notify_preexec() {
  __cmd_notify_started_at=${EPOCHSECONDS}
  __cmd_notify_last_cmd="$1"
}

__cmd_notify_precmd() {
  local exit_status=$?
  local elapsed
  local cmd

  if (( __cmd_notify_started_at <= 0 )); then
    return
  fi

  elapsed=$(( EPOCHSECONDS - __cmd_notify_started_at ))
  __cmd_notify_started_at=0

  if (( elapsed < COMMAND_DONE_NOTIFY_THRESHOLD )); then
    return
  fi

  cmd="$(__cmd_notify_extract_cmd "${__cmd_notify_last_cmd}" || true)"
  if [[ -z "${cmd}" ]]; then
    return
  fi

  if __cmd_notify_should_skip "${cmd}"; then
    return
  fi

  if [[ -r "${HOME}/.config/tmux/notify_shell_command_done.sh" ]]; then
    bash "${HOME}/.config/tmux/notify_shell_command_done.sh" "${elapsed}" "${exit_status}" "${__cmd_notify_last_cmd}" >/dev/null 2>&1 &!
  fi
}

add-zsh-hook preexec __cmd_notify_preexec
add-zsh-hook precmd __cmd_notify_precmd
