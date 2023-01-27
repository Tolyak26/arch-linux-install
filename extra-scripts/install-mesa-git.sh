#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo "- Installing mesa-git packages from AUR ... "
echo ""
sleep 5

yay -S --noconfirm --noeditmenu --needed --removemake --mflags "--skippgpcheck" mesa-git lib32-mesa-git