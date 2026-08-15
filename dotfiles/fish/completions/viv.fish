# ~/.config/fish/completions/viv.fish
complete -c viv -f
complete -c viv -n __fish_use_subcommand -a '(viv --list)'
complete -c viv -s A -l apply   -d '本番実行（APPLY=1）'
complete -c viv -s n -l dry-run -d 'dry-run を明示'
complete -c viv      -l root -r -F -d '走査の起点（ROOT）'
complete -c viv -s e -r         -d 'KEY=VAL を環境変数として渡す'
complete -c viv -s l -l list    -d 'サブコマンド一覧'
complete -c viv -s h -l help    -d 'ヘルプ'
# gh-bulk-sync の第二階層だけ手当てする（残りは素通しなので補完しない）
complete -c viv -n '__fish_seen_subcommand_from gh-bulk-sync' -a add -d '未取得の器を clone する導線'
