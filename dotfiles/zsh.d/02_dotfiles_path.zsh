if [ -d "$HOME/.local/bin" ]; then
  case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
  esac
fi

if [ -n "$DOTFILES_ROOT" ] && [ -d "$DOTFILES_ROOT/bin/agent" ]; then
  case ":$PATH:" in
    *":$DOTFILES_ROOT/bin/agent:"*) ;;
    *) export PATH="$DOTFILES_ROOT/bin/agent:$PATH" ;;
  esac
fi
