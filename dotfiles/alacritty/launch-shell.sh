#!/bin/sh

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
