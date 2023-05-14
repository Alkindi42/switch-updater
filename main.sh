#!/usr/bin/env bash

DOWNLOADS_DIR="downloads"

declare -A FILES=(
	["atmosphere"]="fusee.bin|atmosphere.*.zip"
	["hekate"]="hekate_ctcaer_.*.zip"
)

# Download from repository.
download_from_repository() {
	local name="$1"
	local repository="$2"

	for row in $(echo "$repository" | jq -r -c '.assets[]'); do
		local asset_name=$(echo "$row" | jq -r '.name')
		local url=$(echo "$row" | jq -r '.browser_download_url')

		if [[ $(echo "$asset_name" | grep -E -w "${FILES["$name"]}") ]]; then
			if [[ ! -d "$asset_name" ]]; then
				echo -n "Dowloading $asset_name..."
				curl -s -L "$url" --create-dirs -o "./$DOWNLOADS_DIR/$asset_name"
				echo "done"
			else
				echo "Already here!"
			fi
		fi
	done
}

#
download_from_repositories() {
	local atmosphere_repository="$1"
	local hekate_repository="$2"

	download_from_repository "atmosphere" "$atmosphere_repository" && download_from_repository "hekate" "$hekate_repository"
}

update() {
	local path="$1"

	# If necessary unzip the zips.
	for file in $(ls $DOWNLOADS_DIR/*.zip); do
		local directory="${file%.zip}"

		if [[ ! -d "$directory" ]]; then
			unzip -n -d "$directory" "$file"
		fi
	done

	# Copy files.
	for file in $(ls $DOWNLOADS_DIR/*.zip); do
		local directory="${file%.zip}"

		if [[ "$directory" == *atmosphere* ]]; then
			rsync -a $directory/atmosphere/* "$path/atmosphere/"
			rsync "$directory/hbmenu.nro" "$path/"
			rsync -a $directory/switch/* "$path/switch/"
		elif [[ "$directory" == *hekate* ]]; then
			rsync -a $directory/bootloader/* "$path/bootloader/"
			rsync $directory/hekate_*.bin "$path/payload.bin"
		elif [[ "$directory" == *sigpatches* ]]; then
			rsync -a $directory/atmosphere/* "$path/atmosphere/"
			rsync -a $directory/bootloader/* "$path/bootloader/"
		fi
	done

	rsync "$DOWNLOADS_DIR/fusee.bin" "$path/atmosphere/"
}

main() {
	local volume_path="$1"
	local atmosphere_repository=$(curl -s https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest)
	local hekate_repository=$(curl -s https://api.github.com/repos/CTCaer/hekate/releases/latest)

	# Downloads.
	download_from_repositories "$atmosphere_repository" "$hekate_repository"

	echo -n "Updating..."
	update "$volume_path"

	if [[ "$?" -eq 0 ]]; then
		echo "done."
	else
		echo "failed."
	fi
}

main "$@"
