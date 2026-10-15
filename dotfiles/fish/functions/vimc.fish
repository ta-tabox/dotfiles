function vimc --description 'cmux の左ペインで nvim、右ペインで claude --ide を開く'
    if test -z "$CMUX_SURFACE_ID"
        echo "vimc: cmux の中で実行する" >&2
        return 1
    end

    set -l out (cmux new-split right)
    set -l ref (string match -r 'surface:\d+' -- $out)
    if test -z "$ref"
        echo "vimc: 右ペインを作れなかった: $out" >&2
        return 1
    end

    # nvim (claudecode.nvim) が lock ファイルを書くまで待ってから IDE 接続で起動する
    set -l wait 'for i in (seq 50); grep -rqsF -- "$PWD" ~/.claude/ide; and break; sleep 0.2; end; claude --ide'
    cmux send --surface $ref "cd "(string escape -- $PWD)"; $wait\n" >/dev/null

    # nvim 側が送信後に Claude のペインへフォーカスを移すため、surface を渡す
    env VIMC_CLAUDE_SURFACE=$ref nvim $argv
end
