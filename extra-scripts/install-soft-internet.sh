#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo ""
echo "- Installing packages for internet ... "
echo ""

## Qbittorrent
sudo pacman -S --noconfirm --disable-download-timeout --needed qbittorrent
##

## Discord
sudo pacman -S --noconfirm --disable-download-timeout --needed discord
##

## Telegram
sudo pacman -S --noconfirm --disable-download-timeout --needed telegram-desktop
##

## Xdman
yay -S --noconfirm --needed --removemake xdman 
##

## Google Chrome (Stable)
yay -S --noconfirm --needed --removemake google-chrome
##

## Brave (Binary)
yay -S --noconfirm --needed --removemake brave-bin
##
