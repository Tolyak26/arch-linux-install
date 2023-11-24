#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo ""
echo "- Installing mesa-git packages from AUR ... "
echo ""

yay -S --noconfirm --noeditmenu --needed --removemake --mflags "--skippgpcheck" mesa-git
yay -S --noconfirm --noeditmenu --needed --removemake --mflags "--skippgpcheck" lib32-mesa-git
