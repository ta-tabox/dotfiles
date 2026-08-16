# pnpm global bin
# pnpm 本体は mise が管理する。シェルが持つのは PNPM_HOME と PATH だけで、
# store-dir / global-bin-dir は ~/.config/pnpm/rc が正典。
# activate より前（conf.d）に置くこと。config.fish に置くと global bin が
# mise の installs を追い越し、同名 tool を上書きする。
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not contains "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
