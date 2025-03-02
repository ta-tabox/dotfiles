#!/bin/sh

# 関数の読み込み
dotfiles_root=$(cd $(dirname "$0")/.. && pwd)
. "${dotfiles_root}/scripts/common.sh"

# シンボリックリンクを作成
cd "${dotfiles_root}/dotfiles" || return
linklist="linklist.txt"

# linklist.txt が存在しない場合は終了
if [ ! -r "${linklist}" ]; then
  echo "Error: ${linklist} not found."
  exit 0
fi

# linklist.txt を読み込み、シンボリックリンクを作成
__remove_linklist_comment "${linklist}" | while IFS= read -r line; do
  # 空行やコメント行はスキップ
  if [ -z "${line}" ] || [ "${line:0:1}" = "#" ]; then
    continue
  fi

  # target と link を分割
  IFS=" " read -r target link <<< "${line}"

  # 変数を展開
  target="${PWD}/${target}"
  link="${link/#\~/${HOME}}"

  # シンボリックリンクを作成
  __mkdir "$(dirname "${link}")"
  if ! __ln "${target}" "${link}"; then
    echo "Error: Failed to create symbolic link: ${link}"
  fi
done
