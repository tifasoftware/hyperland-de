#!/bin/bash

# Icons
_ICON_STEP="▸"
_ICON_INFO="→"
_ICON_SUCCESS="✓"
_ICON_ERROR="✗"
_ICON_ARROW="›"

_has_gum() {
  command -v gum &>/dev/null
}

_ensure_gum() {
  if ! _has_gum; then
    echo "Error: gum is required but not installed."
    echo "Install it with: sudo pacman -S gum"
    exit 1
  fi
}

_ensure_gum

log_header() {
  local text="$1"

  echo
  gum style \
    --foreground 2 \
    --border double \
    --border-foreground 2 \
    --padding "0 1" \
    --width 40 \
    --align center \
    "$text"
  echo
}

log_step() {
  local text="$1"

  echo
  gum style \
    --foreground 2 \
    --bold \
    "$_ICON_STEP $text"
}

log_info() {
  local text="$1"

  gum style \
    --foreground 8 \
    "  $_ICON_INFO $text"
}

log_success() {
  local text="$1"

  gum style \
    --foreground 2 \
    "  $_ICON_SUCCESS $text"
}

log_error() {
  local text="$1"

  gum style \
    --foreground 9 \
    --bold \
    "  $_ICON_ERROR $text"
}

log_detail() {
  local text="$1"

  gum style \
    --foreground 8 \
    "    $_ICON_ARROW $text"
}

spinner() {
  local title="$1"
  shift

  gum spin \
    --spinner dot \
    --title "$title" \
    --show-error \
    -- "$@"
}

ask_yes_no() {
  local prompt="$1"

  gum confirm \
    --prompt.foreground=2 \
    --selected.foreground=15 \
    --selected.background=2 \
    "$prompt" && return 0 || return 1
}

log_progress() {
  local text="$1"
  local count="$2"

  gum style \
    --foreground 2 \
    "  [$count] $text"
}

show_done() {
  echo
  gum spin --spinner "dot" --title "Done! Press any key to close..." -- bash -c 'read -n 1 -s'
}
