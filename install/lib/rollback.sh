#!/bin/bash

# Rollback script - restores files from a backup session
# Usage: ./rollback.sh [backup_dir]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

log_info() {
  echo -e "${BLUE}→${NC} $1"
}

log_success() {
  echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
  echo -e "${RED}✗${NC} $1"
}

if [ -n "$1" ]; then
  BACKUP_DIR="$1"
else
  BACKUP_ROOT="$HOME/dotfiles-backup"
  if [ ! -d "$BACKUP_ROOT" ]; then
    log_error "No backups found at $BACKUP_ROOT"
    exit 1
  fi

  BACKUP_DIR=$(ls -1dt "$BACKUP_ROOT"/backup_* 2>/dev/null | head -n1)

  if [ -z "$BACKUP_DIR" ]; then
    log_error "No backup sessions found"
    exit 1
  fi

  log_info "Using most recent backup: $(basename "$BACKUP_DIR")"
fi

RESTORE_FILE="$BACKUP_DIR/RESTORE.txt"

if [ ! -f "$RESTORE_FILE" ]; then
  log_error "RESTORE.txt not found in $BACKUP_DIR"
  exit 1
fi

log_info "$(grep 'Backup created:' "$RESTORE_FILE")"
echo

RESTORE_COUNT=$(grep -cE '^[[:space:]]*Restore:' "$RESTORE_FILE")
if [ "$RESTORE_COUNT" -eq 0 ]; then
  log_error "Backup appears to be empty (no restore commands found)"
  exit 1
fi

BACKUP_FILE_COUNT=$(find "$BACKUP_DIR" -type f -o -type l | wc -l)
log_info "Files/links in backup: $BACKUP_FILE_COUNT"
log_info "Preview of backed up paths:"
grep -E '^\-' "$RESTORE_FILE" | head -10 | while read -r line; do
  echo "  $line"
done
if [ $(grep -E '^\-' "$RESTORE_FILE" | wc -l) -gt 10 ]; then
  log_info "  ... and $(( $(grep -E '^\-' "$RESTORE_FILE" | wc -l) - 10 )) more"
fi
echo

if [[ ! "$BACKUP_DIR" =~ ^"$BACKUP_ROOT" ]] && [[ ! "$BACKUP_DIR" =~ ^/home/[^/]+/\.local/share/dotfiles/dotfiles-backup ]]; then
  log_warning "Backup is not in expected location"
  log_warning "Expected: $BACKUP_ROOT or ~/.local/share/dotfiles/dotfiles-backup"
  log_warning "Actual: $BACKUP_DIR"
  echo
fi

NEEDS_SUDO=false
while IFS= read -r line; do
  if [[ "$line" =~ ^[[:space:]]*Restore:[[:space:]]sudo ]]; then
    NEEDS_SUDO=true
    break
  fi
done < "$RESTORE_FILE"

read -p "Are you sure you want to rollback? This will overwrite current files. [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  log_warning "Rollback cancelled"
  exit 0
fi

if [ "$NEEDS_SUDO" = true ]; then
  log_info "Some files require sudo access..."
  sudo -v || {
    log_error "Sudo authentication failed"
    exit 1
  }
fi

NEEDS_MKINITCPIO_REGEN=false

log_info "Starting rollback..."
echo

RESTORED_COUNT=0
TOTAL_RESTORES=$(grep -cE '^[[:space:]]*Restore:' "$RESTORE_FILE")

while IFS= read -r line; do
  if [[ "$line" =~ ^[[:space:]]*Restore:[[:space:]](.+)$ ]]; then
    restore_cmd="${BASH_REMATCH[1]}"

    log_info "Executing: $restore_cmd"

    if eval "$restore_cmd"; then
      RESTORED_COUNT=$((RESTORED_COUNT + 1))
      log_success "Restored successfully [$RESTORED_COUNT/$TOTAL_RESTORES]"

      if [[ "$restore_cmd" =~ /etc/mkinitcpio\.conf([[:space:]]|$) ]]; then
        NEEDS_MKINITCPIO_REGEN=true
      fi
    else
      log_error "Failed to execute: $restore_cmd"
      log_error "Restored $RESTORED_COUNT/$TOTAL_RESTORES files before failure"
      log_info "You may need to manually fix the failed restoration or re-run rollback"
      exit 1
    fi

    echo
  fi
done < "$RESTORE_FILE"

if [ "$NEEDS_MKINITCPIO_REGEN" = true ]; then
  log_info "Regenerating initramfs (mkinitcpio.conf was restored)..."

  if sudo mkinitcpio -P; then
    log_success "Initramfs regenerated successfully"
    log_warning "System reboot recommended"
  else
    log_error "Failed to regenerate initramfs"
    log_warning "Run 'sudo mkinitcpio -P' manually"
    exit 1
  fi

  echo
fi

log_success "Rollback completed!"
log_info "Original files were at: $BACKUP_DIR"
