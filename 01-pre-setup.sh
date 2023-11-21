#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

script="$( readlink -f "${BASH_SOURCE[0]}" )"
scriptdir="$( dirname "$script" )"

cd "$scriptdir" || exit 1

echo ""
echo "- Setting up setup.conf file ... "
echo ""

if ! source $scriptdir/setup.conf; then
	echo ""
	while true
	do
		read -p "Please enter username: " username
		if [[ "${username,,}" =~ ^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$ ]];
		then
			break
		fi
		echo "Incorrect username."
	done
	echo "username=${username,,}" >> $scriptdir/setup.conf

    read -p "Please enter password: " password
	echo "password=${password,,}" >> $scriptdir/setup.conf

	while true
	do
		read -p "Please name your machine: " nameofmachine
		if [[ "${nameofmachine,,}" =~ ^[a-z][a-z0-9_.-]{0,62}[a-z0-9]$ ]];
		then
			break
		fi
		read -p "Hostname doesn't seem correct. Do you still want to save it? ( y / n ): " force
		if [[ "${force,,}" = "y" ]] || [[ "${force,,}" = "yes" ]];
		then
			break
		fi
	done
    echo "nameofmachine=${nameofmachine,,}" >> $scriptdir/setup.conf

    read -p "Please enter type of your machine ( homepc | tvbox | server | workpc | laptop ): " typeofmachine
	echo "typeofmachine=${typeofmachine,,}" >> $scriptdir/setup.conf

	echo "bootloader=grub" >> $scriptdir/setup.conf

	read -p "Please enter bootloader install path ( /dev/sda | /dev/vda ): " bootloaderinstallpath
	echo "bootloaderinstallpath=${bootloaderinstallpath,,}" >> $scriptdir/setup.conf

	echo "displaymanager=sddm" >> $scriptdir/setup.conf

	read -p "Please enter your desktop environment ( i3 | kde ): " desktopenvironment
	echo "desktopenvironment=${desktopenvironment,,}" >> $scriptdir/setup.conf
fi

source $scriptdir/setup.conf

echo ""
echo "- Updating system clocks ... "
echo ""

timedatectl set-ntp true

echo ""
echo "- Setting up Arch Linux repo mirror for optimal download ... "
echo ""

pacman -S --noconfirm --needed python3 pacman-contrib reflector
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
reflector --country Russia --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

echo ""
echo "- Installing Arch Linux base system ... "
echo ""

pacstrap -K /mnt - < $scriptdir/pkg-lists/pkg-arch-base.txt --noconfirm --needed
echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf
cp -R -v $scriptdir/ /mnt/root/arch-linux-install/

echo ""
echo "- Generating fstab file ... "
echo ""

genfstab -U /mnt >> /mnt/etc/fstab

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

echo ""