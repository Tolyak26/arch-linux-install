#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo ""
echo "- Installing packages for multimedia ... "
echo ""

## Strawberry
sudo pacman -S --noconfirm --disable-download-timeout --needed strawberry
##

## Easytag
sudo pacman -S --noconfirm --disable-download-timeout --needed easytag
##

## VLC
sudo pacman -S --noconfirm --disable-download-timeout --needed vlc
##

## Handbrake
sudo pacman -S --noconfirm --disable-download-timeout --needed handbrake
##

## Music Presence (Binary)
yay -S --noconfirm --needed --removemake music-presence-bin
##

## Spotify (Binary)
yay -S --noconfirm --needed --removemake spotify
##

