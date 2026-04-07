_dotfiles_conf_path="${(%):-%x}"
if [ -L "$_dotfiles_conf_path" ]; then
  _dotfiles_link_target="$(readlink "$_dotfiles_conf_path")"
  if [[ "$_dotfiles_link_target" = /* ]]; then
    _dotfiles_conf_path="$_dotfiles_link_target"
  else
    _dotfiles_conf_path="${_dotfiles_conf_path:A:h}/$_dotfiles_link_target"
  fi
fi

_dotfiles_root="${_dotfiles_conf_path:A:h:h}"
if [ -d "$_dotfiles_root" ]; then
  export DOTFILES_ROOT="$_dotfiles_root"
fi

unset _dotfiles_conf_path _dotfiles_link_target _dotfiles_root
