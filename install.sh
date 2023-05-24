#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

script="$( readlink -f "${BASH_SOURCE[0]}" )"
scriptdir="$( dirname "$script" )"
scriptparentdirname="$(basename "$(dirname "$scriptdir")")"

cd "$scriptdir" || exit 1

pacman -Sy --noconfirm
pacman -S --noconfirm --needed git
git clone https://github.com/Tolyak26/arch-linux-install.git

# Import settings from setup.conf
source $scriptdir/setup.conf

chmod +x $scriptdir/01-pre-setup.sh
chmod +x $scriptdir/02-setup.sh
chmod +x $scriptdir/03-aur.sh
chmod +x $scriptdir/04-post-setup.sh

mkdir -p /mnt/{boot,root,opt}

echo ""

sleep 3
echo "Running 01-pre-setup.sh ... "

$scriptdir/01-pre-setup.sh | tee 01-pre-setup.log

sleep 3
echo "Running 02-setup.sh in root folder ... "

arch-chroot /mnt /root/$scriptparentdirname/02-setup.sh | tee 02-setup.log

sleep 3
echo "Running 03-aur.sh in $username's home folder ... "

arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/$scriptparentdirname/03-aur.sh | tee 03-aur.log

sleep 3
echo "Running 04-post-setup.sh in root folder ... "

arch-chroot /mnt /root/$scriptparentdirname/04-post-setup.sh | tee 04-post-setup.log

sleep 3
echo "Cleaning ... "

echo ""

rm -rf /mnt/root/$scriptparentdirname
rm -rf /mnt/home/$username/$scriptparentdirname

echo "Installation is done! Please reboot your system."