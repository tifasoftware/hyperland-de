#!/bin/bash

DOTFILES_DIR="$HOME/.local/share/dotfiles"

if [ -f "$HOME/.config/starship.toml" ]; then
  rm -f "$HOME/.config/starship.toml"
fi

if [ -d "$HOME/.config/starship" ]; then
  rm -rf "$HOME/.config/starship"
fi

cp -r "$DOTFILES_DIR/config/starship" "$HOME/.config/"

ln -snf "$HOME/.config/starship/configs/config-default.toml" "$HOME/.config/starship.toml"

notify-send -t 10000 "Starship Themes" "You can now switch between starship themes!" 2>/dev/null || true
