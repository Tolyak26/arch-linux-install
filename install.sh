#!/bin/bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

# Import settings from setup.conf
source /root/arch-linux-install/setup.conf

chmod +x /root/arch-linux-install/01-pre-setup.sh
chmod +x /root/arch-linux-install/02-setup.sh
chmod +x /root/arch-linux-install/03-post-setup.sh
chmod +x /root/arch-linux-install/04-aur.sh

echo "Running 01-pre-setup.sh ... "
echo ""
bash /root/arch-linux-install/01-pre-setup.sh
echo ""

echo "Running 02-setup.sh in root folder ... "
echo ""
arch-chroot /mnt /root/arch-linux-install/02-setup.sh
echo ""

echo "Running 03-aur.sh in $username's home folder ... "
echo ""
arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/arch-linux-install/03-aur.sh
echo ""

echo "Running 04-post-setup.sh in root folder ... "
echo ""
arch-chroot /mnt /root/arch-linux-install/04-post-setup.sh
echo ""

echo "Cleaning ... "
echo ""
rm -rf /mnt/root/arch-linux-install
rm -rf /mnt/home/$username/arch-linux-install
echo ""

echo "Installation is done! Please reboot your system."