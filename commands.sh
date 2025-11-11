#!/bin/bash

# Detect distribution
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [[ "$ID" == "cachyos" ]]; then
        DISTRO="cachyos"
    elif [[ "$ID" == "arch" ]] || grep -q "Arch Linux" /etc/os-release 2>/dev/null; then
        DISTRO="arch"
    else
        echo "Error: Unsupported distribution"
        exit 1
    fi
else
    echo "Error: Cannot detect distribution"
    exit 1
fi

echo "Detected distribution: $DISTRO"

# Set source path based on distribution
SOURCE_DIR="/home/$USER/vanillaarch-or-cachyos-to-kdedev/$DISTRO"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory $SOURCE_DIR not found"
    exit 1
fi

# Check if pacman.conf exists in source directory
if [ ! -f "$SOURCE_DIR/pacman.conf" ]; then
    echo "Error: pacman.conf not found in $SOURCE_DIR"
    exit 1
fi

# Backup original pacman.conf
if [ -f /etc/pacman.conf ]; then
    sudo -S cp /etc/pacman.conf /etc/pacman.conf.backup
    echo "Backed up original pacman.conf to /etc/pacman.conf.backup"
fi

# Copy appropriate pacman.conf
sudo -S cp -r "$SOURCE_DIR/pacman.conf" /etc/
echo "Copied $DISTRO pacman.conf to /etc/"

# Continue with the rest of your script
sudo -S pacman -Rsc --noconfirm phonon-qt6
sudo -S pacman -Rsc --noconfirm breeze-gtk
sudo -S pacman -Rsc --noconfirm kcoreaddons
sudo -S pacman -Rsc --noconfirm kconfig
sudo -S pacman -Rsc --noconfirm karchive kconfig
sudo -S pacman -Rsc --noconfirm raptor
sudo -S pacman -Rsc --noconfirm poppler-glib
sudo -S pacman -Rsc --noconfirm harfbuzz-icu
sudo -S pacman -Rsc --noconfirm ark karchive plasma-desktop dolphin kate konsole attica knewstuff discover
sudo -S pacman -Sy
sudo -S pacman -S --noconfirm kdedevpackages kate
