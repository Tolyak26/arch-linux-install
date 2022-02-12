#!/bin/bash

# Import settings from setup.conf
source /root/arch-linux-install/setup.conf

chmod +x /root/arch-linux-install/01-pre-setup.sh
chmod +x /root/arch-linux-install/02-setup.sh
chmod +x /root/arch-linux-install/03-user.sh
chmod +x /root/arch-linux-install/04-post-setup.sh

echo "Launch 01-pre-setup.sh"
echo ""
bash /root/arch-linux-install/01-pre-setup.sh
echo ""

echo "Launch 02-setup.sh in root folder"
echo ""
arch-chroot /mnt /root/arch-linux-install/02-setup.sh
echo ""

echo "Launch 03-user.sh in $USERNAME's home folder"
echo ""
arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/arch-linux-install/03-user.sh
echo ""

echo "Launch 04-post-setup.sh in root folder"
echo ""
arch-chroot /mnt /root/arch-linux-install/04-post-setup.sh