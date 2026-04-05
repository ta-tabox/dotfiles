_dotfiles_conf_path="${(%):-%x}"
if [ -L "$_dotfiles_conf_path" ]; then
  _dotfiles_conf_path="$(readlink "$_dotfiles_conf_path")"
fi
export DOTFILES_ROOT="$(cd "$(dirname "$_dotfiles_conf_path")/.." 2>/dev/null && pwd)"

unset _dotfiles_conf_path
