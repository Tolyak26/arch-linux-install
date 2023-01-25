#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo "- Installing linux-xanmod-x64v3 binary packages for Zen3 from AUR ... "
echo ""
sleep 5

yay -S --noconfirm --noeditmenu --needed --removemake --mflags "--skippgpcheck" linux-xanmod-linux-bin-x64v3 linux-xanmod-linux-headers-bin-x64v3
echo ""
