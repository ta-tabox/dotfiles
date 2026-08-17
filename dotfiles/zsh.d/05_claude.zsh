# Claude Code を共有設定レイヤー付きで起動する
# 共有設定は flagSettings(--settings) として渡し、
# ~/.claude/settings.json (userSettings) はマシンローカル専用にする
claude() {
  local shared="${DOTFILES_ROOT}/claude/settings.shared.json"
  if [ -n "$DOTFILES_ROOT" ] && [ -f "$shared" ]; then
    command claude --settings "$shared" "$@"
  else
    command claude "$@"
  fi
}
