# Switch updater

A small Bash script to update the main files used on my hacked Nintendo Switch SD card.

It currently handles:

* [Atmosphere](https://github.com/Atmosphere-NX/Atmosphere)
* [Hekate](https://github.com/CTCaer/hekate)
* [sys-patch](https://github.com/impeeza/sys-patch)

The script downloads the latest GitHub releases, creates a backup of the current SD card files, then copies the updated files to the SD card.

# Getting started

## Requirements

* bash 4+
* [curl](https://everything.curl.dev/get)
* [jq](https://stedolan.github.io/jq/)
* [rsync](https://doc.ubuntu-fr.org/rsync)
* unzip

## Usage

Connect your Nintendo Switch microSD card to your computer, then run:

```bash
./switch-updater.sh /path/to/sd-card
```

# Using Hekate USB Mass Storage

You can also update the SD card without removing it from the console by using Hekate USB Mass Storage.

Boot into Hekate, mount the SD card from `Tools > USB Tools`, then run:

```bash
./switch-updater.sh /Volumes/Switch
```

# What it does

The script performs the following steps:

1. Checks that all required binaries are installed.
2. Downloads the latest releases for Atmosphere, Hekate and sys-patch.
3. Stores downloaded files in the `downloads/` directory.
4. Tracks downloaded versions in `downloads/versions.env`.
5. Creates a backup of important SD card files in `backups/`.
6. Extracts downloaded archives when needed.
7. Copies the updated files to the SD card.

# Example output

```bash
→ Destination: /Volumes/Switch

Checking releases...
  ✓ atmosphere 1.11.1 already downloaded
  ✓ hekate v6.5.2 already downloaded
  ✓ sys-patch v1.6.2.0 already downloaded

Backup...
  ✓ backup created: /path/to/project/backups/sd-card-2026-05-19

Updating SD card...
  ✓ atmosphere
  ✓ hekate
  ✓ sys-patch
  ✓ fusee.bin

Done.
```

# Backup

Before updating the SD card, the script creates a backup of the files and directories it may overwrite.

Backups are stored in:

```text
backups/
```

A backup is created once per day using the following format:

```text
sd-card-YYYY-MM-DD
```

If a backup already exists for the current day, the script reuses it and does not create another one.

# Downloads and version tracking

Downloaded files are stored in:

```text
downloads/
```

The script keeps track of downloaded versions in:

```text
downloads/versions.env
```

If a release has already been downloaded, the script skips downloading it again.

# Notes

This project is mostly made for my own setup.

It assumes a fairly standard Atmosphere/Hekate/sys-patch SD card layout. It only copies the files it manages and does not intentionally touch unrelated files on the SD card.
