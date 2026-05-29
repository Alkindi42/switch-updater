#!/usr/bin/env bash

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

source "$ROOT_DIR/src/download.sh"
source "$ROOT_DIR/src/update.sh"
source "$ROOT_DIR/src/backup.sh"

declare -a REQUIRED_BINARIES=(
  'curl'
  'jq'
  'rsync'
  'unzip'
)

main() {
  local sd_card_path="$1"

  if [[ -z "$sd_card_path" ]]; then
    printf "Usage: %s /path/to/sd-card\n" "$0" >&2
    return 1
  fi

  if [[ ! -d "$sd_card_path" ]]; then
    printf "SD card path does not exist: %s\n" "$sd_card_path" >&2
    return 1
  fi

  for binary in "${REQUIRED_BINARIES[@]}"; do
    if ! command -v "$binary" &>/dev/null; then
      printf "Required binary not found: %s\n" "$binary" >&2
      return 1
    fi
  done

  printf "→ Destination: %s\n\n" "$sd_card_path"

  printf "\nBackup...\n"
  backup "$sd_card_path" "sd-card" || {
    printf "Backup step failed\n" >&2
    return 1
  }

  printf "Checking releases...\n"
  downloads || {
    printf "Download step failed\n" >&2
    return 1
  }

  printf "\nUpdating SD card...\n"
  update "$sd_card_path" || {
    printf "Update step failed\n" >&2
    return 1
  }

  printf "\nDone.\n"
}

main "$@"
