#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

script="$( readlink -f "${BASH_SOURCE[0]}" )"
scriptdir="$( dirname "$script" )"

cd "$scriptdir" || exit 1

### Preparing archiso for the install - Start ###

pacman -Sy --noconfirm
pacman -S --noconfirm --needed git
git clone https://github.com/Tolyak26/arch-linux-install.git

chmod +x $scriptdir/arch-linux-install/01-pre-setup.sh
chmod +x $scriptdir/arch-linux-install/02-setup.sh
chmod +x $scriptdir/arch-linux-install/03-aur.sh
chmod +x $scriptdir/arch-linux-install/04-post-setup.sh

mkdir -p /mnt/{boot,root,opt}

echo ""

### Preparing archiso for the install - Done ###

### Running 01-pre-setup.sh - Start ###

echo "Running 01-pre-setup.sh ... "

if [[ "$1" == "--debug" ]] || [[ "$1" == "-dbg" ]] || [[ "$1" == "debug" ]] || [[ "$1" == "dbg" ]];
then
    $scriptdir/arch-linux-install/01-pre-setup.sh | tee 01-pre-setup.log
else
    $scriptdir/arch-linux-install/01-pre-setup.sh
fi

### Running 01-pre-setup.sh - Done ###

### Import settings from setup.conf ###
source $scriptdir/arch-linux-install/setup.conf

### Running 02-setup.sh in root folder - Start ###

echo "Running 02-setup.sh in root folder ... "

if [[ "$1" == "--debug" ]] || [[ "$1" == "-dbg" ]] || [[ "$1" == "debug" ]] || [[ "$1" == "dbg" ]];
then
    arch-chroot /mnt /root/arch-linux-install/02-setup.sh | tee 02-setup.log
else
    arch-chroot /mnt /root/arch-linux-install/02-setup.sh
fi

### Running 02-setup.sh in root folder - Done ###

### Running 03-aur.sh in user home folder - Start ###

echo "Running 03-aur.sh in $username's home folder ... "

if [[ "$1" == "--debug" ]] || [[ "$1" == "-dbg" ]] || [[ "$1" == "debug" ]] || [[ "$1" == "dbg" ]];
then
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/arch-linux-install/03-aur.sh | tee 03-aur.log
else
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/arch-linux-install/03-aur.sh
fi

### Running 03-aur.sh in user home folder - Done ###

### Running 04-post-setup.sh in root folder - Start ###

echo "Running 04-post-setup.sh in root folder ... "

if [[ "$1" == "--debug" ]] || [[ "$1" == "-dbg" ]] || [[ "$1" == "debug" ]] || [[ "$1" == "dbg" ]];
then
    arch-chroot /mnt /root/arch-linux-install/04-post-setup.sh | tee 04-post-setup.log
else
    arch-chroot /mnt /root/arch-linux-install/04-post-setup.sh
fi

### Running 04-post-setup.sh in root folder - Done ###

### Cleaning - Start ###

echo "Cleaning ... "

echo ""

rm -rf /mnt/root/arch-linux-install
rm -rf /mnt/home/$username/arch-linux-install

### Cleaning - Done ###

echo "Installation is done! Please reboot your system."
