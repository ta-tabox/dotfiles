#!/bin/sh

# 関数の読み込み
dotfiles_root=$(cd $(dirname "$0")/.. && pwd)
. "${dotfiles_root}/scripts/common.sh"

# シンボリックリンクを削除
cd "${dotfiles_root}/dotfiles" || return
linklist="linklist.txt"

# linklist.txt が存在しない場合は終了
if [ ! -r "${linklist}" ]; then
  echo "Error: ${linklist} not found."
  exit 0
fi

# linklist.txtをループ処理
# read -r で\をエスケープとして使用しない
cat ${linklist} | while IFS= read -r line; do
  # 空行やコメント行はスキップ
  if [ -z "${line}" ] || [ "${line:0:1}" = "#" ]; then
    continue
  fi

  # target と link を分割
  IFS=" " read -r target link <<< "${line}"

  # 変数を展開
  link="${link/#\~/${HOME}}"

  # シンボリックリンクを作成
  if ! __unlink "${link}"; then
    echo "Error: Failed to create symbolic link: ${link}"
  fi
done
