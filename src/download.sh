#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

DOWNLOADS_DIR="$ROOT_DIR/downloads"
VERSIONS_FILE="$DOWNLOADS_DIR/versions.env"

declare -A FILES=(
  ["syspatch"]="sys-patch-.*.zip"
  ["atmosphere"]="fusee.bin|atmosphere.*.zip"
  ["hekate"]="hekate_ctcaer_.*.zip"
)

downloads() {
  local hekate_json
  local syspatch_json
  local atmosphere_json

  mkdir -p "$DOWNLOADS_DIR"

  hekate_json="$(curl -fsSL https://api.github.com/repos/CTCaer/hekate/releases/latest)" || return 1
  syspatch_json="$(curl -fsSL https://api.github.com/repos/impeeza/sys-patch/releases/latest)" || return 1
  atmosphere_json="$(curl -fsSL https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest)" || return 1

  download_from_github_repository "atmosphere" "$atmosphere_json" || return 1
  download_from_github_repository "hekate" "$hekate_json" || return 1
  download_from_github_repository "syspatch" "$syspatch_json" || return 1
}

get_current_version() {
  local name="$1"

  source "$VERSIONS_FILE" 2>/dev/null || true

  case "$name" in
  atmosphere) echo "${ATMOSPHERE_VERSION:-}" ;;
  hekate) echo "${HEKATE_VERSION:-}" ;;
  syspatch) echo "${SYSPATCH_VERSION:-}" ;;
  esac
}

save_version() {
  local name="$1"
  local version="$2"

  source "$VERSIONS_FILE" 2>/dev/null || true

  case "$name" in
  atmosphere) ATMOSPHERE_VERSION="$version" ;;
  hekate) HEKATE_VERSION="$version" ;;
  syspatch) SYSPATCH_VERSION="$version" ;;
  esac

  cat >"$VERSIONS_FILE" <<EOF
ATMOSPHERE_VERSION=${ATMOSPHERE_VERSION:-}
HEKATE_VERSION=${HEKATE_VERSION:-}
SYSPATCH_VERSION=${SYSPATCH_VERSION:-}
EOF
}

download_from_github_repository() {
  local name="$1"
  local repository="$2"

  local tag
  local html_url
  local current_version
  local downloaded=false

  html_url="$(jq -r ".html_url" <<<"$repository")"

  if [[ -z "$html_url" ]]; then
    printf "Invalid GitHub release JSON for %s\n" "$name" >&2
    return 1
  fi

  tag="${html_url##*/}"
  current_version="$(get_current_version "$name")"

  if [[ "$tag" == "$current_version" ]]; then
    printf "%s already up to date (%s)\n" "$name" "$tag"
    return 0
  fi

  while read -r row; do
    local asset_name
    local url
    local output_path

    asset_name="$(jq -r '.name' <<<"$row")"
    url="$(jq -r '.browser_download_url' <<<"$row")"
    output_path="$DOWNLOADS_DIR/$asset_name"

    if [[ "$asset_name" =~ ${FILES[$name]} ]]; then
      printf "Downloading %s..." "$asset_name"
      if curl -fsSL "$url" --create-dirs -o "$output_path"; then
        printf '✔\n'
        downloaded=true
      else
        printf '✘\n'
        return 1
      fi
    fi
  done < <(jq -r -c '.assets[]?' <<<"$repository")

  if [[ "$downloaded" == true ]]; then
    save_version "$name" "$tag"
  else
    printf "No asset found for %s\n" "$name" >&2
    return 1
  fi

}
