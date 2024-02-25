#!/bin/sh

dotfiles_root=$(cd $(dirname $0)/.. && pwd)
. ${dotfiles_root}/scripts/common.sh

# シンボリックリンクを削除
cd ${dotfiles_root}/dotfiles
linklist="linklist.txt"

[ ! -r "${linklist}" ] && continue

__remove_linklist_comment "$linklist" | while read target link; do
	# ~ や環境変数を展開
	link=$(eval echo "${link}")
	# シンボリックリンクを作成
	__unlink ${link}
done
