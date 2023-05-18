#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

pacman -Sy --noconfirm
pacman -S --noconfirm --needed git
git clone https://github.com/Tolyak26/arch-linux-install.git

# Import settings from setup.conf
source /root/arch-linux-install/setup.conf

chmod +x /root/arch-linux-install/01-pre-setup.sh
chmod +x /root/arch-linux-install/02-setup.sh
chmod +x /root/arch-linux-install/03-aur.sh
chmod +x /root/arch-linux-install/04-post-setup.sh

mkdir -p /mnt/{boot,root,opt}

echo "Running 01-pre-setup.sh ... "
echo ""
sleep 5

/root/arch-linux-install/01-pre-setup.sh |& tee 01-pre-setup.log
echo ""

echo "Running 02-setup.sh in root folder ... "
echo ""
sleep 5

arch-chroot /mnt /root/arch-linux-install/02-setup.sh |& tee 02-setup.log
echo ""

echo "Running 03-aur.sh in $username's home folder ... "
echo ""
sleep 5

arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/arch-linux-install/03-aur.sh |& tee 03-aur.log
echo ""

echo "Running 04-post-setup.sh in root folder ... "
echo ""
sleep 5

arch-chroot /mnt /root/arch-linux-install/04-post-setup.sh |& tee 04-post-setup.log
echo ""

echo "Cleaning ... "
echo ""
sleep 5

rm -rf /mnt/root/arch-linux-install
rm -rf /mnt/home/$username/arch-linux-install
echo ""

sleep 5

echo "Installation is done! Please reboot your system."