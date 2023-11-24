#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo ""
echo "- Installing mesa-git packages from AUR ... "
echo ""

yay -R --noconfirm libva-mesa-driver mesa mesa-libgl mesa-vdpau opencl-clover-mesa opencl-rusticl-mesa vulkan-intel vulkan-mesa-layers vulkan-radeon vulkan-swrast
yay -R --noconfirm lib32-libva-mesa-driver lib32-mesa lib32-mesa-libgl lib32-mesa-vdpau lib32-vulkan-intel lib32-vulkan-mesa-layers lib32-vulkan-radeon

yay -S --noconfirm --noeditmenu --needed --removemake --mflags "--skippgpcheck" mesa-git lib32-mesa-git
