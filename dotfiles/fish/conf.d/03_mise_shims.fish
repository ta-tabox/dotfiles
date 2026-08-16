# mise shims を PATH に常駐させる。
# `mise activate` が書くのは版番号込みの絶対パスなので、起動時の環境を
# 凍結するプロセス（GUI アプリ・launchd・シェルスナップショット）では
# tool 更新のたびに dangling になる。shims は版非依存でそれに耐える。
# ここは config.fish の activate より前に走るため、対話シェルでは
# 従来どおり installs の直パスが優先される。
set -l _mise_shims "$HOME/.local/share/mise/shims"
if test -d "$_mise_shims"; and not contains "$_mise_shims" $PATH
    set -gx PATH "$_mise_shims" $PATH
end
