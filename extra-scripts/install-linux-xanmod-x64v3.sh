#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo ""
echo "- Installing linux-xanmod-x64v3 binary packages for Zen3 from AUR ... "
echo ""

yay -S --noconfirm --noeditmenu --needed --removemake --mflags "--skippgpcheck" linux-xanmod-linux-bin-x64v3 linux-xanmod-linux-headers-bin-x64v3

sleep 3
echo ""
echo "- Updating /boot/grub/grub.cfg ... "
echo ""

sudo grub-mkconfig -o /boot/grub/grub.cfg