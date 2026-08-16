# mise shims を PATH に常駐させる。
# `mise activate` が書くのは版番号込みの絶対パスなので、起動時の環境を
# 凍結するプロセス（GUI アプリ・launchd・シェルスナップショット）では
# tool 更新のたびに dangling になる。shims は版非依存でそれに耐える。
# ここは library.zsh の activate より前に走るため、対話シェルでは
# 従来どおり installs の直パスが優先される。
#
# zsh.d は .zshrc 経由＝対話シェルでしか読まれない。素の `zsh -c` まで
# 覆うには ~/.zshenv にも同じ行が要る。
if [ -d "$HOME/.local/share/mise/shims" ]; then
  case ":$PATH:" in
    *":$HOME/.local/share/mise/shims:"*) ;;
    *) export PATH="$HOME/.local/share/mise/shims:$PATH" ;;
  esac
fi
