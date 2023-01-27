#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo "- Installing linux-xanmod-x64v3 binary packages for Zen3 from AUR ... "
echo ""
sleep 5

yay -S --noconfirm --noeditmenu --needed --removemake --mflags "--skippgpcheck" linux-fsync-nobara-bin
echo ""

echo "- Updating /boot/grub/grub.cfg ... "
echo ""
sleep 5

grub-mkconfig -o /boot/grub/grub.cfg