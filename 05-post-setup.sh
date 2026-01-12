#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

set -x

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
systemctl enable nxserver
systemctl enable avahi-daemon
systemctl enable libvirtd
systemctl enable toggle-gpp0-to-fix-wakeup
systemctl enable power-profiles-daemon

### Enabling services - Done ###

### Enabling auto-start for apps in the user folder - Start ###

echo ""
echo "- Enabling auto-start for apps in the user folder ... "
echo ""

mkdir -p /home/$username/.config/autostart
mkdir -p /etc/skel/.config/autostart

# Octopi Notifier
cp -v /usr/share/applications/octopi-notifier.desktop /etc/xdg/autostart

chown -R $username:users /home/$username/.config/autostart

### Enabling auto-start for apps in the user folder - Done ###

### Updating /boot/grub/grub.cfg - Start ###

echo ""
echo "- Updating /boot/grub/grub.cfg ... "
echo ""

grub-mkconfig -o /boot/grub/grub.cfg

### Updating /boot/grub/grub.cfg - Done ###

### Removing pubring.db.lock - Start ###

echo ""
echo "- Removing pubring.db.lock ... "
echo ""

rm /home/$username/.gnupg/public-keys.d/pubring.db.lock

### Removing pubring.db.lock - Done ###

echo ""
