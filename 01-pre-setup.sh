#!/bin/bash

# Get current script path
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Import settings from setup.conf
source $SCRIPT_DIR/setup.conf

echo "- Update system clocks"
echo ""
timedatectl set-ntp true

echo "- Setting up Yandex Arch Linux repo mirror for optimal download"
echo ""
pacman -S --noconfirm pacman-contrib
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
echo -ne "Server = https://mirror.yandex.ru/archlinux/$repo/os/$arch" > /etc/pacman.d/mirrorlist
chmod 644 /etc/pacman.d/mirrorlist

echo "- Install Arch Linux base packages"
echo ""
#pacstrap /mnt base base-devel linux linux-firmware