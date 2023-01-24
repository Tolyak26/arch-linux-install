#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

# Import settings from setup.conf
source /root/arch-linux-install/setup.conf

echo "- Enabling services ... "
echo ""
sleep 5

ntpd -qg
systemctl enable ntpd
systemctl enable cups
systemctl enable bluetooth
systemctl enable sddm
systemctl disable dhcpcd
systemctl stop dhcpcd
systemctl enable NetworkManager
systemctl enable smb
systemctl enable nmb
systemctl enable winbind
systemctl enable sshd
systemctl enable teamviewerd
systemctl enable vboxservice
echo ""

echo "- Updating /boot/grub/grub.cfg ... "
echo ""
sleep 5

grub-mkconfig -o /boot/grub/grub.cfg