#!/bin/bash

_GREEN='\033[0;32m'
_BLUE='\033[0;34m'
_YELLOW='\033[1;33m'
_RED='\033[0;31m'
_CYAN='\033[0;36m'
_NC='\033[0m'

_ICON_STEP="▸"
_ICON_INFO="→"
_ICON_SUCCESS="✓"
_ICON_ERROR="✗"
_ICON_ARROW="›"

_has_gum() {
    command -v gum &> /dev/null
}

is_installed() {
    pacman -Q "$1" &>/dev/null
}

ensure_gum() {
    if ! is_installed "gum"; then
        echo "Installing gum for better UI..."
        sudo pacman -S --noconfirm gum
    fi
}

log_header() {
    local text="$1"

    if _has_gum; then
        echo
        gum style \
            --foreground 108 \
            --border double \
            --border-foreground 108 \
            --padding "0 2" \
            --margin "1 0" \
            --width 50 \
            --align center \
            "$text"
        echo
    else
        echo -e "\n${_GREEN}════════════════════════════════════════${_NC}"
        echo -e "${_GREEN}  $text${_NC}"
        echo -e "${_GREEN}════════════════════════════════════════${_NC}\n"
    fi
}

log_step() {
    local text="$1"

    if _has_gum; then
        echo
        gum style \
            --foreground 108 \
            --bold \
            "$_ICON_STEP $text"
    else
        echo -e "\n${_GREEN}$_ICON_STEP${_NC} $text"
    fi
}

log_info() {
    local text="$1"

    if _has_gum; then
        gum style \
            --foreground 246 \
            "  $_ICON_INFO $text"
    else
        echo -e "  ${_YELLOW}$_ICON_INFO${_NC} $text"
    fi
}

log_success() {
    local text="$1"

    if _has_gum; then
        gum style \
            --foreground 108 \
            "  $_ICON_SUCCESS $text"
    else
        echo -e "  ${_GREEN}$_ICON_SUCCESS${_NC} $text"
    fi
}

log_error() {
    local text="$1"

    if _has_gum; then
        gum style \
            --foreground 196 \
            --bold \
            "  $_ICON_ERROR $text"
    else
        echo -e "  ${_RED}$_ICON_ERROR${_NC} $text"
    fi
}

log_detail() {
    local text="$1"

    if _has_gum; then
        gum style \
            --foreground 241 \
            "    $_ICON_ARROW $text"
    else
        echo -e "    ${_CYAN}$_ICON_ARROW${_NC} $text"
    fi
}

spinner() {
    local title="$1"
    shift

    if _has_gum; then
        gum spin \
            --spinner dot \
            --title "$title" \
            --show-error \
            -- "$@"
    else
        echo -e "${_CYAN}⟳${_NC} $title"
        "$@"
    fi
}

ask_yes_no() {
    local prompt="$1"

    if _has_gum; then
        gum confirm "$prompt" && return 0 || return 1
    else
        while true; do
            read -p "$prompt [y/n]: " yn
            case $yn in
                [Yy]* ) return 0;;
                [Nn]* ) return 1;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    fi
}

log_progress() {
    local text="$1"
    local count="$2"

    if _has_gum; then
        gum style \
            --foreground 108 \
            "  [$count] $text"
    else
        echo -e "  ${_CYAN}[$count]${_NC} $text"
    fi
}

detect_hardware_type() {
    if ls /sys/class/power_supply/BAT* >/dev/null 2>&1 || [ -d /sys/class/power_supply/battery ]; then
        echo "laptop"
    else
        echo "desktop"
    fi
}

has_nvidia_gpu() {
    lspci | grep -i nvidia &>/dev/null
}

remove_path() {
    local target="$1"

    if [ -L "$target" ] && [ ! -e "$target" ]; then
        rm -f "$target"
    elif [ -e "$target" ]; then
        rm -rf "$target"
    fi
}
