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

echo "- Optimizing makeflags configuration for your CPU ... "
echo ""
get_cpu_core_count=$(grep -c ^processor /proc/cpuinfo)
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$get_cpu_core_count\"/g" /etc/makepkg.conf
sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $get_cpu_core_count -z -)/g" /etc/makepkg.conf
echo ""

echo "- Installing additional packages for Arch Linux system ... "
echo ""
pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-arch-additional.txt
echo ""

echo "- Installing NetworkManager packages ... "
echo ""
pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-networkmanager.txt
echo ""

echo "- Installing microcode package for CPU ... "
echo ""
get_cpu_vendor=$(lscpu)
if grep -E "GenuineIntel" <<< ${get_cpu_vendor}; then
    echo "Installing Intel microcode package"
    pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-microcode-intel.txt
elif grep -E "AuthenticAMD" <<< ${get_cpu_vendor}; then
    echo "Installing AMD microcode package"
    pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-microcode-amd.txt
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

echo "- Installing ALSA, PulseAudio packages for Sound hardware ... "
echo ""
pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-driver-sound.txt
echo ""

echo "- Installing packages for Bluetooth hardware ... "
echo ""
pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-driver-bluetooth.txt
echo ""

echo "- Installing Xorg packages ... "
echo ""
pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-xorg.txt
echo ""

echo "- Generating mkinitcpio ... "
echo ""
mkinitcpio -P
echo ""

echo "- Installing GRUB Bootloader packages ... "
echo ""
pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-bootloader-grub.txt
if [[ -d "/sys/firmware/efi" ]]; then
	grub-install --target=i386-efi --efi-directory=/boot /dev/sda
else
	grub-install --target=i386-pc --boot-directory=/boot /dev/sda
fi
grub-mkconfig -o /boot/grub/grub.cfg
echo ""

echo "- Setting up sudo without no password rights for users ... "
echo ""
sed -i 's/^# %wheel/%wheel/' /etc/sudoers
echo ""

echo "- Adding user $username"
echo ""
useradd -m -g users -G audio,games,lp,optical,power,scanner,storage,video,wheel -s /bin/bash $username
echo "$username:$password" | chpasswd
rm -rf /home/$username/arch-linux-install
cp -R /root/arch-linux-install /home/$username/
chown -R $username: /home/$username/arch-linux-install
echo ""

echo "- Setting up system locale and timezone ... "
echo ""
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
tee -a /etc/locale.conf << EOF
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8
LC_MESSAGES=en_US.UTF-8
LC_TIME=en_US.UTF-8
LANG=en_US.UTF-8
EOF
ln -sf /usr/share/zoneinfo/Asia/Krasnoyarsk /etc/localtime
hwclock --systohc
timedatectl set-ntp true
echo ""

echo "- Setiing up /etc/hosts & /etc/hostname"
echo ""
tee -a /etc/hosts << EOF
127.0.0.1        localhost
::1              localhost
127.0.1.1        $nameofmachine
EOF
echo $nameofmachine > /etc/hostname
echo ""

echo "- Installing Samba packages ... "
echo ""
pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-samba.txt
echo ""

echo "- Installing SDDM display manager packages ... "
echo ""
pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-displaymanager-sddm.txt
echo ""

echo "- Installing i3 desktop packages ... "
echo ""
pacman -S --noconfirm --needed - < /root/arch-linux-install/pkg-lists/pkg-desktop-i3.txt