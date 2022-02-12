#!/bin/bash

# Get current script path
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Import settings from setup.conf
source $SCRIPT_DIR/setup.conf

echo "Launch 01-pre-setup.sh"
echo ""
bash 01-pre-setup.sh

echo "Launch 02-setup.sh in root folder"
echo ""
arch-chroot /mnt /root/arch-linux-install/02-setup.sh

echo "Launch 03-user.sh in $USERNAME's home folder"
echo ""
arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/arch-linux-install/03-user.sh

echo "Launch 04-post-setup.sh in root folder"
echo ""
arch-chroot /mnt /root/arch-linux-install/04-post-setup.sh
