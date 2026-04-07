set _dotfiles_conf_path (status filename)
if test -L "$_dotfiles_conf_path"
    set _dotfiles_link_target (readlink "$_dotfiles_conf_path")

    if string match -qr '^/' -- "$_dotfiles_link_target"
        set _dotfiles_conf_path "$_dotfiles_link_target"
    else
        set _dotfiles_conf_path (path resolve "$(path dirname "$_dotfiles_conf_path")/$_dotfiles_link_target")
    end
end

set _dotfiles_root (path resolve "$(path dirname "$_dotfiles_conf_path")/../..")

if test -d "$_dotfiles_root"
    set -gx DOTFILES_ROOT "$_dotfiles_root"
end

set -e _dotfiles_conf_path
set -e _dotfiles_link_target
set -e _dotfiles_root
