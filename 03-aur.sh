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

function InstallAURPackages()
{
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

   for aur_de_pkgs in $( cat $scriptdir/pkg-lists/pkg-aur-desktopenvironment-$desktopenvironment.txt )
   do
      __AURHelperDoJob $aur_de_pkgs
   done

   sleep 1
   echo ""
   echo "- Installing AUR User Software packages ... "
   echo ""

   for aur_user_soft in $( cat $scriptdir/pkg-lists/pkg-aur-user-soft.txt )
   do
      __AURHelperDoJob $aur_user_soft
   done
}

# Import settings from setup.conf
source $scriptdir/setup.conf

InstallAURPackages

echo ""