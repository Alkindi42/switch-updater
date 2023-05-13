# Switch updater

I have a hacked Nintendo Switch.

When Nintendo updates its Firmware, I have to do some updates on my side to continue enjoying my console:

* [Atmosphere](https://github.com/Atmosphere-NX/Atmosphere)
* [Hekate](https://github.com/CTCaer/hekate)
* [Sigpatches](https://hackintendo.com/download/sigpatches-atmosphere-esfsloader/)

I have created a script that automate the update.

# Getting started.
1. Connect your micro SD card to your computer.
2. Run the script to update. It needs the path to your micro SD card.

Example from my laptop (I'm using OS X) :

```bash
bash update.sh /Volumes/Nintendo-switch
```

# How it works?

1. The script creates a backup of your micro SD card.
2. The script checks if you really need an update (version comparison).
3. The script replaces the necessary files in your micro SD card (it does not touch other files).
4. That's all.

# How to rollback?
The script created a mess? Do not worry, there is a command to rollback.
```
bask update.sh rollback
```

The script will copy your backup to your micro SD card as if you had never run this script.

If you have a problem, feel free to create an issue or create a PR.
