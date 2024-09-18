#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

set -x

script="$( readlink -f "${BASH_SOURCE[0]}" )"
scriptdir="$( dirname "$script" )"

cd "$scriptdir" || exit 1

### Setting up setup.conf file - Start ###

echo ""
echo "- Setting up setup.conf file ... "
echo ""

if ! source $scriptdir/setup.conf; then
	echo ""
	while true
	do
		read -p "Please enter username: " username
		if [[ "${username}" =~ ^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$ ]];
		then
			break
		fi
		echo "Incorrect username."
	done
	echo "username=${username}" >> $scriptdir/setup.conf

    read -p "Please enter password: " password
	echo "password=${password}" >> $scriptdir/setup.conf

	while true
	do
		read -p "Please name your machine: " nameofmachine
		if [[ "${nameofmachine}" =~ ^[a-z][a-z0-9_.-]{0,62}[a-z0-9]$ ]];
		then
			break
		fi
		read -p "Hostname doesn't seem correct. Do you still want to save it? ( y / n ): " force
		if [[ "${force,,}" = "y" ]] || [[ "${force,,}" = "yes" ]];
		then
			break
		fi
	done
    echo "nameofmachine=${nameofmachine}" >> $scriptdir/setup.conf

    read -p "Please enter type of your machine ( homepc | tvbox | server | workpc | laptop ): " typeofmachine
	echo "typeofmachine=${typeofmachine,,}" >> $scriptdir/setup.conf

    read -p "Please enter your favorite bootloader ( grub ): " bootloader
	echo "bootloader=${bootloader,,}" >> $scriptdir/setup.conf

	read -p "Please enter bootloader install path ( /dev/sda | /dev/vda ): " bootloaderinstallpath
	echo "bootloaderinstallpath=${bootloaderinstallpath,,}" >> $scriptdir/setup.conf

    read -p "Please enter your favorite display manager ( sddm ): " displaymanager
	echo "displaymanager=${displaymanager,,}" >> $scriptdir/setup.conf

	read -p "Please enter your desktop environment ( i3 | kde ): " desktopenvironment
	echo "desktopenvironment=${desktopenvironment,,}" >> $scriptdir/setup.conf

    read -p "Please enter your favorite sound server ( pulseaudio | pipewire ): " soundserver
	echo "soundserver=${soundserver,,}" >> $scriptdir/setup.conf
fi

source $scriptdir/setup.conf

### Setting up setup.conf file - Done ###

### Updating system clocks - Start ###

echo ""
echo "- Updating system clocks ... "
echo ""

timedatectl set-ntp true

### Updating system clocks - Done ###

### Setting up Arch Linux repo mirror for optimal download - Start ###

echo ""
echo "- Setting up Arch Linux repo mirror for optimal download ... "
echo ""

pacman -S --noconfirm --needed python3 pacman-contrib reflector
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
reflector --country Russia --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

### Setting up Arch Linux repo mirror for optimal download - Done ###

### Installing Arch Linux base system - Start ###

echo ""
echo "- Installing Arch Linux base system ... "
echo ""

pacstrap -K /mnt - < $scriptdir/pkg-lists/pkg-arch-base.txt --noconfirm --needed
echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf
echo "keyserver hkps://keys.openpgp.org" >> /mnt/etc/pacman.d/gnupg/gpg.conf
echo "keyserver hkp://keys.gnupg.net" >> /mnt/etc/pacman.d/gnupg/gpg.conf
echo "keyserver hkps://pgp.mit.edu" >> /mnt/etc/pacman.d/gnupg/gpg.conf
cp -R -v $scriptdir/ /mnt/root/arch-linux-install/

### Installing Arch Linux base system - Done ###

### Generating fstab file - Start ###

echo ""
echo "- Generating fstab file ... "
echo ""

genfstab -U /mnt >> /mnt/etc/fstab

### Generating fstab file - Done ###

### Making swap file for low memory systems <8GB - Start ###

echo ""
echo "- Making swap file for low memory systems <8GB ... "
echo ""

get_total_memory=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')
if [ $get_total_memory -lt 8000000 ]; then
    dd if=/dev/zero of=/mnt/swapfile bs=1M count=2048 status=progress
    chmod 600 /mnt/swapfile
    chown root /mnt/swapfile
    mkswap /mnt/swapfile
    echo "/swapfile none swap sw 0 0" >> /mnt/etc/fstab
fi

### Making swap file for low memory systems <8GB - Done ###

echo ""
