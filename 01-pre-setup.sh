#!/usr/bin/env bash

# Import settings from setup.conf
source /root/arch-linux-install/setup.conf

echo "- Update system clocks"
echo ""
timedatectl set-ntp true
echo ""

echo "- Setting up Yandex Arch Linux repo mirror for optimal download"
echo ""
pacman -S --noconfirm pacman-contrib
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
cp /root/arch-linux-install/configs/etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist
echo ""

echo "- Install Arch Linux base system"
echo ""
pacstrap /mnt base base-devel linux linux-firmware linux-headers dkms --noconfirm --needed
echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf
rm -rf /mnt/root/arch-linux-install
cp -R /root/arch-linux-install /mnt/root/arch-linux-install
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
echo ""

echo "- Generate new fstab file"
echo ""
genfstab -U /mnt >> /mnt/etc/fstab
