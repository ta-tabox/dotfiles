set _dotfiles_conf_path (status filename)
if test -L "$_dotfiles_conf_path"
    set _dotfiles_conf_path (readlink "$_dotfiles_conf_path")
end

set _dotfiles_root (begin
    cd (dirname "$_dotfiles_conf_path")/.. 2>/dev/null
    and pwd
end)

if test -n "$_dotfiles_root"
    set -gx DOTFILES_ROOT "$_dotfiles_root"
end

set -e _dotfiles_conf_path
set -e _dotfiles_root
