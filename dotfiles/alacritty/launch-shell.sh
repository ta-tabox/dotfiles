#!/bin/sh

# Ensure common Homebrew paths are available (for GUI app launches with limited PATH).
# Covers Apple Silicon, Intel macOS, and Linuxbrew defaults.
for p in \
  /opt/homebrew/bin \
  /opt/homebrew/sbin \
  /usr/local/bin \
  /usr/local/sbin \
  "$HOME/.linuxbrew/bin" \
  "$HOME/.linuxbrew/sbin"
do
  [ -d "$p" ] || continue
  case ":$PATH:" in
    *":$p:"*) ;;
    *) PATH="$p:$PATH" ;;
  esac
done
export PATH

# If brew is available, normalize PATH for custom prefixes as well.
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

# Start or attach tmux session when tmux is available.
if command -v tmux >/dev/null 2>&1; then
  exec tmux new-session -A -s main
fi

# Fallback shell selection without hardcoded full paths.
if command -v fish >/dev/null 2>&1; then
  exec fish -l
fi

if command -v zsh >/dev/null 2>&1; then
  exec zsh -l
fi

exec sh -l
