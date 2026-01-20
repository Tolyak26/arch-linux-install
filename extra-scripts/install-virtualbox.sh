#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

if [ -z "${username}" ]; then
	username="$(id -un)"
fi

echo ""
echo "- Installing VirtualBox ... "
echo ""

sudo pacman -S --noconfirm --disable-download-timeout --needed virtualbox virtualbox-host-dkms virtualbox-guest-iso

sudo usermod -aG vboxusers $username

sudo modprobe vboxdrv
sudo modprobe vboxnetadp
sudo modprobe vboxnetflt
