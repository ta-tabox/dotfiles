# pnpm global bin（fish 側 conf.d/04_pnpm.fish と対）
# pnpm 本体は mise が管理する。シェルが持つのは PNPM_HOME と PATH だけで、
# store-dir / global-bin-dir は ~/.config/pnpm/rc が正典。
# PATH へ足すのは PNPM_HOME 直ではなく PNPM_HOME/bin。
export PNPM_HOME="$HOME/.local/share/pnpm"
if [ -d "$PNPM_HOME/bin" ]; then
  case ":$PATH:" in
    *":$PNPM_HOME/bin:"*) ;;
    *) export PATH="$PNPM_HOME/bin:$PATH" ;;
  esac
fi
