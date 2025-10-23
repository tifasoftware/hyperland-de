#!/bin/bash

BACKUP_ROOT="$HOME/dotfiles-backup"
SESSION_FILE="$HOME/.local/share/dotfiles/.dotfiles-backup-session"

init_backup_session() {
  local BACKUP_SESSION="backup_$(date +%Y%m%d_%H%M%S)"
  local BACKUP_DIR="$BACKUP_ROOT/$BACKUP_SESSION"
  local RESTORE_FILE="$BACKUP_DIR/RESTORE.txt"

  mkdir -p "$BACKUP_DIR"

  cat > "$SESSION_FILE" <<EOF
BACKUP_SESSION="$BACKUP_SESSION"
BACKUP_DIR="$BACKUP_DIR"
RESTORE_FILE="$RESTORE_FILE"
EOF

  cat > "$RESTORE_FILE" <<EOF
Backup created: $(date '+%Y-%m-%d %H:%M:%S')
Source: dotfiles installation

Files backed up:
EOF

  local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [ -f "$SCRIPT_DIR/rollback.sh" ]; then
    cp "$SCRIPT_DIR/rollback.sh" "$BACKUP_DIR/rollback.sh"
    chmod +x "$BACKUP_DIR/rollback.sh"
  fi

  # Create visible reminder to view hidden files
  touch "$BACKUP_DIR/ENABLE-HIDDEN-FILES-VIEW.txt"

  echo "$BACKUP_SESSION"
}

backup_file() {
  local source_path="$1"

  if [ -z "$BACKUP_DIR" ]; then
    if [ ! -f "$SESSION_FILE" ]; then
      echo "ERROR: No backup session initialized" >&2
      return 1
    fi
    source "$SESSION_FILE"
  fi

  if [ ! -e "$source_path" ]; then
    return 1
  fi

  local rel_path="${source_path#/}"  
  local backup_path="$BACKUP_DIR/$rel_path"
  local backup_parent="$(dirname "$backup_path")"

  mkdir -p "$backup_parent" || {
    echo "ERROR: Failed to create backup directory: $backup_parent" >&2
    return 1
  }

  if [[ "$source_path" =~ ^"$HOME" ]]; then
    cp -rP "$source_path" "$backup_path" || {
      echo "ERROR: Failed to backup: $source_path" >&2
      return 1
    }
  else
    sudo cp -rP "$source_path" "$backup_path" || {
      echo "ERROR: Failed to backup: $source_path" >&2
      return 1
    }
  fi

  local rm_cmd cp_cmd restore_cmd
  if [ -d "$source_path" ]; then
    rm_cmd="rm -rf \"$source_path\""
    cp_cmd="cp -rP \"$BACKUP_DIR/$rel_path\" \"$(dirname "$source_path")/\""
  else
    rm_cmd="rm -f \"$source_path\""
    cp_cmd="cp -P \"$BACKUP_DIR/$rel_path\" \"$source_path\""
  fi

  if [[ ! "$source_path" =~ ^"$HOME" ]]; then
    rm_cmd="sudo $rm_cmd"
    cp_cmd="sudo $cp_cmd"
  fi

  restore_cmd="$rm_cmd && $cp_cmd"

  cat >> "$RESTORE_FILE" <<EOF

- $source_path
  Restore: $restore_cmd
EOF

  return 0
}
