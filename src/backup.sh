#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
BACKUPS_DIR="$ROOT_DIR/backups"

BACKUP_FILES=(
  "atmosphere"
  "bootloader"
  "switch"
  "payload.bin"
  "hbmenu.nro"
)

backup() {
  local path="$1"
  local name="$2"

  local backup_path
  local item
  local sources=()

  if [[ -z "$path" ]]; then
    printf "Missing source path for backup\n" >&2
    return 1
  fi

  if [[ -z "$name" ]]; then
    name="sd-card"
  fi

  backup_path="$BACKUPS_DIR/$name-$(date "+%Y-%m-%d")"

  if [[ -d "$backup_path" ]]; then
    printf "  ✓ backup already exists: %s\n" "$backup_path"
    return 0
  fi

  mkdir -p "$BACKUPS_DIR"

  for item in "${BACKUP_FILES[@]}"; do
    if [[ -e "$path/$item" ]]; then
      sources+=("$path/$item")
    fi
  done

  if [[ "${#sources[@]}" -eq 0 ]]; then
    printf "No files found to backup in %s\n" "$path" >&2
    return 1
  fi

  if rsync -az "${sources[@]}" "$backup_path/"; then
    printf "  ✓ backup created: %s\n" "$backup_path"
  else
    printf "  ✘ backup failed\n" >&2
    return 1
  fi
}
