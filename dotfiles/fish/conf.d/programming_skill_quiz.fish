# =============================================================
# Python出題トレーニング用の fish 関数
#
# 実態は dotfiles 側に置き、fish の conf.d 自動読み込みに乗せる方針。
# プロジェクト側(shell/quiz.fish)は dotfiles へのシンボリックリンク。
# 配置先が conf.d なら config.fish への手動 source は不要(fishが起動時に自動sourceする)。
#
# 導入(1回だけ・dotfiles管理):
#   mkdir -p ~/dotfiles/dotfiles/fish/conf.d
#   mv  ~/Claude/Projects/programming_skill/shell/quiz.fish ~/dotfiles/dotfiles/fish/conf.d/quiz.fish
#   ln -s ~/dotfiles/dotfiles/fish/conf.d/quiz.fish ~/Claude/Projects/programming_skill/shell/quiz.fish
#   # ~/.config/fish/conf.d/ がdotfilesを指していなければ、そこにもリンクを張る:
#   #   ln -s ~/dotfiles/dotfiles/fish/conf.d/quiz.fish ~/.config/fish/conf.d/quiz.fish
#   exec fish   # 反映
#
# 使い方:
#   pyq         今日の未解答クイズを開始（雛形生成 → 解答フォルダへ移動 → vim で solution.py）
#   pyq --id X  特定クイズIDを指定して開始
#   pyqt        いま取り組み中のクイズをテスト（どこで実行してもOK）
#   pyqd        ダッシュボードHTMLを再生成
# =============================================================

set -g QUIZ_PROJ ~/vivarium/hatchery

function pyq --description "今日のPythonクイズを開始(雛形生成＋vim)"
    python3 $QUIZ_PROJ/scripts/work.py start $argv; or return
    set -l sol (python3 $QUIZ_PROJ/scripts/work.py path $argv)
    cd (dirname $sol)        # ./run.sh が使えるよう解答フォルダへ移動
    vim $sol
end

function pyqt --description "現在のクイズをテスト"
    python3 $QUIZ_PROJ/scripts/work.py test $argv
end

function pyqd --description "ダッシュボードを再生成"
    python3 $QUIZ_PROJ/scripts/build_dashboard.py
    and python3 $QUIZ_PROJ/scripts/build_kb.py
end
