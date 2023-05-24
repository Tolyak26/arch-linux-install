#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

script="$( readlink -f "${BASH_SOURCE[0]}" )"
scriptdir="$( dirname "$script" )"

cd "$scriptdir" || exit 1

# Import settings from setup.conf
source $scriptdir/setup.conf

echo ""
echo "- Enabling services ... "
echo ""

ntpd -qg
systemctl enable ntpd.service
systemctl enable cups.service
systemctl enable bluetooth.service
systemctl enable sddm.service
systemctl disable dhcpcd.service
systemctl enable NetworkManager.service
systemctl enable smb.service
systemctl enable nmb.service
systemctl enable winbind.service
systemctl enable sshd.service
systemctl enable teamviewerd.service
systemctl enable nxserver.service

sleep 5
echo ""
echo "- Updating /boot/grub/grub.cfg ... "
echo ""

grub-mkconfig -o /boot/grub/grub.cfg

echo ""