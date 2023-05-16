# Switch updater

I have a hacked Nintendo Switch.

When Nintendo updates its Firmware, I have to do some updates on my side to continue enjoying my console:

* [Atmosphere](https://github.com/Atmosphere-NX/Atmosphere)
* [Hekate](https://github.com/CTCaer/hekate)
* [Sigpatches](https://hackintendo.com/download/sigpatches-atmosphere-esfsloader/)

I have created a script that automate the update.

# Getting started.

## Dependencies
* bash > 4.0
* [curl](https://everything.curl.dev/get)
* [jq](https://stedolan.github.io/jq/)
* [rsync](https://doc.ubuntu-fr.org/rsync)

1. Connect your micro SD card to your computer.
2. Run the script to update. It needs the path to your micro SD card.

Example from my laptop (I'm using OS X) :

```bash
./main.sh /Volumes/Switch
```

or

```bash
bash main.sh /Volumes/Switch
```

# How it works?

1. The script creates a backup of your micro SD card (if you don't already have one).
2. The script downloads all the necessary files in `./downloads' directory.
3. The script replaces the necessary files in your micro SD card (it does not touch other files).
4. That's all.

# Backup
Backup can take a long time, it depends on your micro SD card and data size. It might be interesting to only backup files that we know the script will overwrite. To be honest, I never use the backup feature so I don't want to improve it, especially because I know no one else will use this script. So who am I talking to? I don't know but if you want something feel free to open an issue or PR.
