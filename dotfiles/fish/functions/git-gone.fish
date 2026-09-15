function git-gone --description '追跡先が消えた/マージ済みのローカルブランチを刈る'
    if not command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo 'git-gone: gitリポジトリの中で実行する' >&2
        return 1
    end

    # remoteが無いリポジトリではfetch自体が失敗するので触らない
    if test (count (command git remote)) -gt 0
        if not command git fetch --prune
            echo 'git-gone: fetch に失敗した。gone 判定は当てにならない' >&2
        end
    end

    # baseはorigin/HEADから取り、取れなければmainとみなす
    set -l base (command git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | string replace -r '^origin/' '')
    test -n "$base"; or set base main

    # マージ判定はorigin/baseとローカルbaseの両方で見る。
    # 前者だけだとローカルでマージしてまだpushしていない分を、
    # 後者だけだとローカルbaseがpullされていない分を取りこぼす
    set -l base_refs
    for ref in origin/$base $base
        command git rev-parse --verify --quiet $ref >/dev/null; and set -a base_refs $ref
    end

    # refname|track|worktreepath。右から割るのでブランチ名に | が入っても壊れない
    set -l fmt '%(refname:short)|%(upstream:track)|%(worktreepath)'
    set -l names
    set -l reasons

    # 追跡先が消えたもの。worktreepathが非空なら現在checkout中か他のworktreeが掴んでいる
    for line in (command git for-each-ref refs/heads --format=$fmt)
        set -l f (string split -r -m 2 -- '|' $line)
        test "$f[1]" = "$base"; and continue
        test -n "$f[3]"; and continue
        if test "$f[2]" = '[gone]'
            set -a names $f[1]
            set -a reasons gone
        end
    end

    # baseにマージ済みのもの。upstreamの有無を問わない
    for base_ref in $base_refs
        for line in (command git for-each-ref refs/heads --merged=$base_ref --format=$fmt)
            set -l f (string split -r -m 2 -- '|' $line)
            test "$f[1]" = "$base"; and continue
            test -n "$f[3]"; and continue
            contains -- $f[1] $names; and continue
            set -a names $f[1]
            set -a reasons merged
        end
    end

    if test (count $names) -eq 0
        echo 'git-gone: 削除対象のブランチは無い'
        return 0
    end

    set -l base_label (string join ', ' $base_refs)
    test -n "$base_label"; or set base_label '不明'
    printf 'git-gone: 以下 %d 本を削除する (base: %s)\n' (count $names) $base_label
    for i in (seq (count $names))
        printf '  %s (%s)\n' $names[$i] $reasons[$i]
    end

    read -l -P 'git branch -D で削除する [y/N]: ' answer
    if not string match -qir '^y(es)?$' -- $answer
        echo 'git-gone: 中止した'
        return 1
    end

    command git branch -D $names
end
