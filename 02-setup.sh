#!/usr/bin/env bash

# Get current script path
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Import settings from setup.conf
source $SCRIPT_DIR/setup.conf

echo "- Install additional packages for Arch Linux system"
echo ""
pacman -S --noconfirm --needed - < $SCRIPT_DIR/pkg-lists/pkg-arch-additional.txt
echo ""

echo "- Generate mkinitcpio"
echo ""
mkinitcpio -P
echo ""

echo "- Install & configure GRUB Bootloader"
echo ""
pacman -S --noconfirm --needed grub os-prober
if [[ -d "/sys/firmware/efi" ]]; then
	grub-install --efi-directory=/boot /dev/sda
else
	grub-install --boot-directory=/boot /dev/sda
fi

grub-mkconfig -o /boot/grub/grub.cfg
echo ""