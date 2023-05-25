#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

script="$( readlink -f "${BASH_SOURCE[0]}" )"
scriptdir="$( dirname "$script" )"

cd "$scriptdir" || exit 1

function __AURHelperDoJob()
{
   yay -S --noconfirm --needed --noeditmenu --removemake $1 
}

export -f __AURHelperDoJob

# Import settings from setup.conf
source $scriptdir/setup.conf

echo ""
echo "- Installing AUR Helper ... "
echo ""

cd $HOME
git clone https://aur.archlinux.org/yay.git
cd $HOME/yay
sudo pacman -S --noconfirm --needed go
makepkg -si --noconfirm --needed
rm -rf $HOME/yay

sleep 1
echo ""
echo "- Installing AUR Desktop Environment packages ... "
echo ""

__AURHelperDoJob '{}' < $scriptdir/pkg-lists/pkg-aur-desktopenvironment-$desktopenvironment.txt

sleep 1
echo ""
echo "- Installing AUR User Software packages ... "
echo ""

__AURHelperDoJob '{}' < $scriptdir/pkg-lists/pkg-aur-user-soft.txt

echo ""