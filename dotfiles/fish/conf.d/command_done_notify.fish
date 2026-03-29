# 長時間コマンド完了時の通知
# - しきい値以上の実行時間
# - 除外コマンド以外
# のときに、音 / tmux / macOS 通知を送る

if not set -q COMMAND_DONE_NOTIFY_THRESHOLD
    set -g COMMAND_DONE_NOTIFY_THRESHOLD 15
end

set -l __cmd_notify_ignore_file "$HOME/.config/tmux/command_done_notify_ignore.list"

function __cmd_notify_load_default_ignore --argument-names file
    if not test -r "$file"
        return 1
    end

    set -l values
    while read -l line
        set line (string trim -- "$line")
        if test -z "$line"
            continue
        end
        if string match -qr '^#' -- "$line"
            continue
        end
        set -a values "$line"
    end < "$file"

    if test (count $values) -gt 0
        set -g COMMAND_DONE_NOTIFY_IGNORE $values
        return 0
    end

    return 1
end

if not set -q COMMAND_DONE_NOTIFY_IGNORE
    __cmd_notify_load_default_ignore "$__cmd_notify_ignore_file" >/dev/null 2>&1
end

set -g __cmd_notify_started_at 0
set -g __cmd_notify_last_cmd ""

function __cmd_notify_extract_cmd --argument-names raw
    set raw (string trim -- "$raw")
    if test -z "$raw"
        return 1
    end

    set -l words (string split ' ' -- "$raw")
    set -l cmd_words
    set -l seen_cmd 0
    for w in $words
        if string match -rq '^[A-Za-z_][A-Za-z0-9_]*=' -- "$w"
            continue
        end

        switch "$w"
            case sudo env command builtin nocorrect noglob time nohup
                continue
            case '--'
                continue
            case '-*'
                if test $seen_cmd -eq 0
                    continue
                end
                set -a cmd_words "$w"
            case '*'
                if test $seen_cmd -eq 0
                    set -a cmd_words (path basename "$w")
                    set seen_cmd 1
                else
                    set -a cmd_words "$w"
                end
        end
    end

    if test (count $cmd_words) -eq 0
        return 1
    end

    echo (string lower -- (string join ' ' -- $cmd_words))
end

function __cmd_notify_should_skip --argument-names cmd
    for ignored in $COMMAND_DONE_NOTIFY_IGNORE
        set -l ignored_lc (string lower -- "$ignored")
        if test "$cmd" = "$ignored_lc"
            return 0
        end
        if string match -q -- "$ignored_lc *" "$cmd"
            return 0
        end
    end
    return 1
end

function __cmd_notify_preexec --on-event fish_preexec
    set -g __cmd_notify_started_at (date +%s)
    set -g __cmd_notify_last_cmd "$argv[1]"
end

function __cmd_notify_postexec --on-event fish_postexec
    set -l exit_status $status
    if test "$__cmd_notify_started_at" -le 0
        return
    end

    set -l now (date +%s)
    set -l elapsed (math "$now - $__cmd_notify_started_at")
    set -g __cmd_notify_started_at 0

    if test $elapsed -lt $COMMAND_DONE_NOTIFY_THRESHOLD
        return
    end

    set -l cmd (__cmd_notify_extract_cmd "$__cmd_notify_last_cmd" 2>/dev/null)
    if test -z "$cmd"
        return
    end

    if __cmd_notify_should_skip "$cmd"
        return
    end

    if test -r "$HOME/.config/tmux/notify_shell_command_done.sh"
        /bin/bash "$HOME/.config/tmux/notify_shell_command_done.sh" "$elapsed" "$exit_status" "$__cmd_notify_last_cmd" >/dev/null 2>&1 </dev/null & disown
    end
end
