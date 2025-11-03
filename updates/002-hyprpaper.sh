#!/bin/bash

DOTFILES_DIR="$HOME/.local/share/dotfiles"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"

if pacman -Qi swaybg &>/dev/null; then
  sudo pacman -Rns swaybg --noconfirm 2>/dev/null || true
fi

if pacman -Qi waypaper &>/dev/null; then
  sudo pacman -Rns waypaper --noconfirm 2>/dev/null || true
fi

if ! pacman -Qi hyprpaper &>/dev/null; then
  sudo pacman -S hyprpaper --noconfirm 2>/dev/null || true
fi

pkill -x swaybg 2>/dev/null || true

if [ ! -f "$HYPRPAPER_CONF" ]; then
  cat > "$HYPRPAPER_CONF" <<EOC
preload = ~/.local/share/dotfiles/current/background
wallpaper = , ~/.local/share/dotfiles/current/background
ipc = true
EOC
fi

pkill hyprpaper 2>/dev/null || true

uwsm app -- hyprpaper >/dev/null 2>&1 &

for i in {1..10}; do
  if hyprctl hyprpaper listloaded &>/dev/null; then
    break
  fi
  sleep 0.2
done

hyprctl hyprpaper reload ,"$HOME/.local/share/dotfiles/current/background" 2>/dev/null || true

hyprctl reload 2>/dev/null || true

notify-send -t 10000 "Hyprpaper Migration" "Migrated from swaybg to hyprpaper!" 2>/dev/null || true
