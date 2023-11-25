#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

script="$( readlink -f "${BASH_SOURCE[0]}" )"
scriptdir="$( dirname "$script" )"

cd "$scriptdir" || exit 1

### Import settings from setup.conf ###
source $scriptdir/setup.conf

### Enabling services - Start ###

echo ""
echo "- Enabling services ... "
echo ""

systemctl enable ntpd
systemctl enable cups
systemctl enable bluetooth
systemctl enable sddm
systemctl disable dhcpcd
systemctl enable NetworkManager
systemctl enable smb
systemctl enable nmb
systemctl enable winbind
systemctl enable sshd
systemctl enable teamviewerd
systemctl enable nxserver
systemctl enable avahi-daemon

### Enabling services - Done ###

### Enabling auto-start for apps in the user folder - Start ###

### Enabling auto-start for apps in the user folder - Done ###

### Installing AppImage's - Start ###

### Installing AppImage's - Done ###

### Updating /boot/grub/grub.cfg - Start ###

echo ""
echo "- Updating /boot/grub/grub.cfg ... "
echo ""

grub-mkconfig -o /boot/grub/grub.cfg

### Updating /boot/grub/grub.cfg - Done ###

echo ""
