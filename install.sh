#!/bin/bash

# Get current script path
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Import settings from setup.conf
source $SCRIPT_DIR/setup.conf

echo "Launch 01-pre-setup.sh"
echo ""
chmod +x 01-pre-setup.sh
bash 01-pre-setup.sh
echo ""

echo "Launch 02-setup.sh in root folder"
echo ""
chmod +x /mnt/root/arch-linux-install/02-setup.sh
arch-chroot /mnt /root/arch-linux-install/02-setup.sh
echo ""

echo "Launch 03-user.sh in $USERNAME's home folder"
echo ""
chmod +x /mnt/home/$USERNAME/arch-linux-install/03-user.sh
arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/arch-linux-install/03-user.sh
echo ""

echo "Launch 04-post-setup.sh in root folder"
echo ""
chmod +x /mnt/root/arch-linux-install/04-post-setup.sh
arch-chroot /mnt /root/arch-linux-install/04-post-setup.sh