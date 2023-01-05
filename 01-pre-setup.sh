#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

# Setting up setup.conf file
echo "- Setting up setup.conf file ... "
echo ""
if ! source /root/arch-linux-install/setup.conf; then
	while true
	do
		read -p "Please enter username:" username
		if [[ "${username,,}" =~ ^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$ ]]
		then
			break
		fi
		echo "Incorrect username."
	done
	echo "username=${username,,}" >> /root/arch-linux-install/setup.conf

    read -p "Please enter password:" password
	echo "password=${password,,}" >> /root/arch-linux-install/setup.conf

	while true
	do
		read -p "Please name your machine:" nameofmachine
		if [[ "${nameofmachine,,}" =~ ^[a-z][a-z0-9_.-]{0,62}[a-z0-9]$ ]]
		then
			break
		fi
		read -p "Hostname doesn't seem correct. Do you still want to save it? (y/n)" force
		if [[ "${force,,}" = "y" ]]
		then
			break
		fi
	done
    echo "nameofmachine=${nameofmachine,,}" >> /root/arch-linux-install/setup.conf

	echo "bootloader=grub" >> /root/arch-linux-install/setup.conf
	echo "nameofmachine=sddm" >> /root/arch-linux-install/setup.conf
	echo "nameofmachine=i3" >> /root/arch-linux-install/setup.conf
fi
source /root/arch-linux-install/setup.conf
echo ""

echo "- Updating system clocks ... "
echo ""
timedatectl set-ntp true
echo ""

echo "- Setting up Arch Linux repo mirror for optimal download ... "
echo ""
pacman -S --noconfirm --needed pacman-contrib
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
cp /root/arch-linux-install/cfg-files/etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist
echo ""

echo "- Installing Arch Linux base system ... "
echo ""
pacstrap -K /mnt - < /root/arch-linux-install/pkg-lists/pkg-arch-base.txt --noconfirm --needed
echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf
cp -R /root/arch-linux-install/ /mnt/root/arch-linux-install/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
echo ""

echo "- Generating fstab file ... "
echo ""
genfstab -U /mnt >> /mnt/etc/fstab
echo ""

echo "- Making swap file for low memory systems <8GB ... "
echo ""
get_total_memory=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*')
if [ $get_total_memory -lt 8000000 ]; then
    mkdir /mnt/opt/swap
    dd if=/dev/zero of=/mnt/opt/swap/swapfile bs=1M count=2048 status=progress
    chmod 600 /mnt/opt/swap/swapfile
    chown root /mnt/opt/swap/swapfile
    mkswap /mnt/opt/swap/swapfile
    echo "/opt/swap/swapfile	none	swap	sw	0	0" >> /mnt/etc/fstab
fi