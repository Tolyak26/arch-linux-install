#!/bin/bash

# Получение пути каталога скрипта
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo -ne "Import settings from setup.conf"
echo ""
source $SCRIPT_DIR/setup.conf

echo -ne "Launch 01-pre-setup.sh"
echo ""
bash 01-pre-setup.sh

echo -ne "Launch 02-setup.sh in root folder"
echo ""
arch-chroot /mnt /root/arch-linux-install/02-setup.sh

echo -ne "Launch 03-user.sh in $USERNAME's home folder"
echo ""
arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/arch-linux-install/03-user.sh

echo -ne "Launch 04-post-setup.sh in root folder"
echo ""
arch-chroot /mnt /root/arch-linux-install/04-post-setup.sh
