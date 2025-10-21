#!/bin/bash

source "$HOME/.local/share/dotfiles/bin/lib/helpers.sh"

set -e

log_header "Node.js Setup"

if [ "$EUID" -eq 0 ]; then
  log_error "Don't run this script as root/sudo"
  exit 1
fi

log_step "Installing nvm..."
if [ -d "$HOME/.config/nvm" ]; then
  log_info "nvm already installed"
else
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  log_success "nvm installed"
fi

log_step "Loading nvm..."
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

log_step "Installing Node.js v24..."
nvm install 24
log_success "Node.js installed"

log_step "Verifying installation..."
NODE_VERSION=$(node -v)
NPM_VERSION=$(npm -v)
log_success "Node.js $NODE_VERSION"
log_success "npm $NPM_VERSION"

show_done
