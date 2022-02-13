#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

# Import settings from setup.conf
source /root/arch-linux-install/setup.conf

echo "- Optimizing pacman for optimal download ... "
echo ""
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
cp /root/arch-linux-install/cfg-files/etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist
pacman -Sy --noconfirm
echo ""

echo "- Optimizing makeflags configuration with your CPU ... "
echo ""
get_cpu_core_count=$(grep -c ^processor /proc/cpuinfo)
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$get_cpu_core_count\"/g" /etc/makepkg.conf
sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $get_cpu_core_count -z -)/g" /etc/makepkg.conf
echo ""

echo "- Installing NetworkManager package ... "
echo ""
pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-networkmanager.txt
echo ""

echo "- Installing additional packages for Arch Linux system ... "
echo ""
pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-arch-additional.txt
echo ""

echo "- Installing Xorg packages ... "
echo ""
pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-xorg.txt
echo ""

echo "- Installing microcode package for CPU ... "
echo ""
get_cpu_vendor=$(lscpu)
if grep -E "GenuineIntel" <<< ${get_cpu_vendor}; then
    echo "Installing Intel microcode package"
    pacman -S --noconfirm - < /root/arch-linux-install/pkg-lists/pkg-microcode-intel.txt
elif grep -E "AuthenticAMD" <<< ${get_cpu_vendor}; then
    echo "Installing AMD microcode package"
    pacman -S --noconfirm - < /root/arch-linux-install/pkg-lists/pkg-microcode-amd.txt
fi
echo ""

echo "- Installing driver packages for GPU ... "
echo ""
get_gpu_vendor=$(lspci)
if grep -E "NVIDIA|GeForce" <<< ${get_gpu_vendor}; then
	echo "Installing NVIDIA packages"
    pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-driver-video-nvidia.txt
	sed -i 's/^MODULES=()/MODULES=(nvidia)/' /etc/mkinitcpio.conf
	nvidia-xconfig
elif lspci | grep 'VGA' | grep -E "AMD"; then
	echo "Installing AMDGPU packages"
    pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-driver-video-amd.txt
	sed -i 's/^MODULES=()/MODULES=(amdgpu)/' /etc/mkinitcpio.conf
elif lspci | grep 'VGA' | grep -E "ATI"; then
	echo "Installing ATI Legacy packages"
    pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-driver-video-ati.txt
	sed -i 's/^MODULES=()/MODULES=(radeon)/' /etc/mkinitcpio.conf
elif grep -E "Integrated Graphics Controller" <<< ${get_gpu_vendor}; then
	echo "Installing Intel packages"
    pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-driver-video-intel.txt
	sed -i 's/^MODULES=()/MODULES=(i915)/' /etc/mkinitcpio.conf
elif grep -E "Intel Corporation UHD" <<< ${get_gpu_vendor}; then
	echo "Installing Intel packages"
    pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-driver-video-intel.txt
	sed -i 's/^MODULES=()/MODULES=(i915)/' /etc/mkinitcpio.conf
fi
echo ""

echo "- Generating mkinitcpio ... "
echo ""
mkinitcpio -P
echo ""

echo "- Installing & configuring GRUB Bootloader package ... "
echo ""
pacman -S --noconfirm --needed < /root/arch-linux-install/pkg-lists/pkg-bootloader-grub.txt
if [[ -d "/sys/firmware/efi" ]]; then
	grub-install --efi-directory=/boot /dev/sda
else
	grub-install --boot-directory=/boot /dev/sda
fi
grub-mkconfig -o /boot/grub/grub.cfg