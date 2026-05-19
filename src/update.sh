#!/usr/bin/env bash

: "${DOWNLOADS_DIR:?DOWNLOADS_DIR must be defined before sourcing update.sh}"

extract_all_archives() {
  local file
  local name

  shopt -s nullglob

  for file in "$DOWNLOADS_DIR"/*.zip; do
    name="${file%.zip}"

    if [[ ! -d "$name" ]]; then
      unzip -n -q -d "$name" "$file"
    fi
  done

  shopt -u nullglob
}

update() {
  local destination_path="$1"
  local directory

  extract_all_archives || return 1

  shopt -s nullglob

  # Copy files.
  for file in "$DOWNLOADS_DIR"/*.zip; do
    directory="${file%.zip}"

    if [[ "$directory" == *atmosphere* ]]; then
      rsync -a "$directory/atmosphere/" "$destination_path/atmosphere/"
      rsync "$directory/hbmenu.nro" "$destination_path/"
      rsync -a "$directory/switch/" "$destination_path/switch/"
      printf "  ✓ atmosphere\n"
    elif [[ "$directory" == *hekate* ]]; then
      rsync -a "$directory/bootloader/" "$destination_path/bootloader/"
      rsync "$directory/hekate_"*.bin "$destination_path/payload.bin"
      printf "  ✓ hekate\n"
    elif [[ "$directory" == *sys-patch* ]]; then
      rsync -a "$directory/atmosphere/" "$destination_path/atmosphere/"
      rsync -a "$directory/switch/" "$destination_path/switch/"
      printf "  ✓ sys-patch\n"
    else
      continue
    fi
  done

  if [[ -f "$DOWNLOADS_DIR/fusee.bin" ]]; then
    rsync "$DOWNLOADS_DIR/fusee.bin" "$destination_path/atmosphere/"
    printf "  ✓ fusee.bin\n"
  fi

  shopt -u nullglob
}
