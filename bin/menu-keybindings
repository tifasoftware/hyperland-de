#!/bin/bash

hypr_config="$HOME/.config/hypr/hyprland.conf"
config_file=$(grep -E 'source.*keybindings\.conf' "$hypr_config" | awk '{print $3}')

config_file="${config_file/#\~/$HOME}"

if [[ -z "$config_file" || ! -f "$config_file" ]]; then
  config_file="$HOME/.local/share/dotfiles/default/hypr/conf/desktop-keybindings.conf"
fi

parse_keybindings() {
  awk -F'#' '
    # Extract variable definitions
    /^\$mainMod/ {
      gsub(/.*=[ \t]*/, "", $1)
      mainMod = $1
      next
    }
    /^\$terminal/ {
      gsub(/.*=[ \t]*/, "", $1)
      terminal = $1
      next
    }

    # Process bind lines with descriptions
    /^bind[em]? = / && NF > 1 {
      binding = $1
      desc = $2

      # Clean up description
      gsub(/^[ \t]+|[ \t]+$/, "", desc)

      # Skip if no description
      if (desc == "") next

      # Extract the part after "bind[em]? = "
      sub(/^bind[em]? = /, "", binding)

      # Split on first comma to get modifiers+key
      match(binding, /([^,]*),[ \t]*([^,]+)/, parts)
      mods = parts[1]
      key = parts[2]

      # Resolve variables
      gsub(/\$mainMod/, mainMod, mods)
      gsub(/\$terminal/, terminal, key)

      # Clean up whitespace
      gsub(/^[ \t]+|[ \t]+$/, "", mods)
      gsub(/^[ \t]+|[ \t]+$/, "", key)

      # Format output
      if (mods == "" || mods == " ") {
        key_combo = key
      } else {
        key_combo = mods " + " key
      }

      printf "%-35s → %s\n", key_combo, desc
    }
  ' "$config_file"
}

monitor_height=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .height')
menu_height=$((monitor_height * 40 / 100))

parse_keybindings | walker --dmenu --theme menus -p 'Keybindings' --width 800 --maxheight "$menu_height"
