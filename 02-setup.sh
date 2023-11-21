#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

script="$( readlink -f "${BASH_SOURCE[0]}" )"
scriptdir="$( dirname "$script" )"

cd "$scriptdir" || exit 1

# Import settings from setup.conf
source $scriptdir/setup.conf

echo ""
echo "- Optimizing pacman for optimal download ... "
echo ""

pacman -S --noconfirm --needed python3 reflector
#sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
reflector --country Russia --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
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

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-arch-additional.txt

echo ""
echo "- Installing NetworkManager packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-networkmanager.txt

echo ""
echo "- Installing microcode packages for CPU ... "
echo ""

get_cpu_vendor=$(lscpu)
if grep -E "GenuineIntel" <<< ${get_cpu_vendor}; then
    echo "Installing Intel microcode package"
    pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-microcode-intel.txt
elif grep -E "AuthenticAMD" <<< ${get_cpu_vendor}; then
    echo "Installing AMD microcode package"
    pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-microcode-amd.txt
fi

echo ""
echo "- Installing Xorg packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-xorg.txt

echo ""
echo "- Installing Wayland packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-wayland.txt

echo ""
echo "- Installing driver packages for GPU ... "
echo ""

get_gpu_vendor=$(lspci)
if grep -E "NVIDIA|GeForce" <<< ${get_gpu_vendor}; then
	echo "Installing NVIDIA packages"
    pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-video-nvidia.txt
	sed -i 's/^MODULES=()/MODULES=(nvidia)/' /etc/mkinitcpio.conf
	nvidia-xconfig
elif lspci | grep 'VGA' | grep -E "Radeon HD"; then
	echo "Installing ATI Legacy packages"
    pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-video-ati.txt
	sed -i 's/^MODULES=()/MODULES=(radeon)/' /etc/mkinitcpio.conf
elif lspci | grep 'VGA' | grep -E "AMD"; then
	echo "Installing AMDGPU packages"
    pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-video-amd.txt
	sed -i 's/^MODULES=()/MODULES=(amdgpu)/' /etc/mkinitcpio.conf
elif grep -E "Integrated Graphics Controller" <<< ${get_gpu_vendor}; then
	echo "Installing Intel packages"
    pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-video-intel.txt
	sed -i 's/^MODULES=()/MODULES=(i915)/' /etc/mkinitcpio.conf
elif grep -E "Intel Corporation UHD" <<< ${get_gpu_vendor}; then
	echo "Installing Intel packages"
    pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-video-intel.txt
	sed -i 's/^MODULES=()/MODULES=(i915)/' /etc/mkinitcpio.conf
fi

echo ""
echo "- Installing packages for Virtual Machine Environment ... "
echo ""

get_vm_product=$(dmidecode -t system | grep -E 'Product Name:' | awk '{split ($0, a, ": "); print a[2]}')
if grep -E "VirtualBox" <<< ${get_vm_product}; then
    echo "Installing VirtualBox packages"
    pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-vm-virtualbox.txt
	systemctl enable vboxservice.service
elif grep -E "VMware" <<< ${get_vm_product}; then
    echo "Installing VMWare packages"
    pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-vm-vmware.txt
	systemctl enable vmtoolsd.service vmware-vmblock-fuse.service
fi

echo ""
echo "- Installing ALSA, PulseAudio packages for Sound hardware ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-sound.txt

echo ""
echo "- Installing packages for Bluetooth hardware ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-bluetooth.txt

echo ""
echo "- Generating mkinitcpio ... "
echo ""

mkinitcpio -P

echo ""
echo "- Installing Bootloader packages ... "
echo ""

if [ $bootloader == "grub" ]; then
	pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-bootloader-$bootloader.txt
	if [[ -d "/sys/firmware/efi" ]]; then
		grub-install --target=x86_64-efi --efi-directory=/boot $bootloaderinstallpath 
	else
		grub-install --target=i386-pc $bootloaderinstallpath
	fi

	get_cpu_vendor=$(lscpu)
	if grep -E "GenuineIntel" <<< ${get_cpu_vendor}; then
		sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on iommu=pt /' /etc/default/grub
	elif grep -E "AuthenticAMD" <<< ${get_cpu_vendor}; then
		sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="amd_iommu=on iommu=pt video=efifb:off /' /etc/default/grub
	fi

	sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="net.ifnames=0 /' /etc/default/grub
	sed -i 's/^GRUB_DISABLE_RECOVERY=true/GRUB_DISABLE_RECOVERY=false/' /etc/default/grub
	sed -i 's/^#GRUB_DISABLE_OS_PROBER/GRUB_DISABLE_OS_PROBER/' /etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg
fi

echo ""
echo "- Installing Display Manager packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-displaymanager-$displaymanager.txt

echo ""
echo "- Installing Desktop Environment packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-desktopenvironment-$desktopenvironment.txt

echo ""
echo "- Installing Samba packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-samba.txt

echo ""
echo "- Installing Media Codec packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-media-codecs.txt

echo ""
echo "- Installing User Software packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-user-soft.txt

echo ""
echo "- Installing theme files ... "
echo ""

if [ $desktopenvironment == "i3" ]; then
tar -xf $scriptdir/theme-files/icons/McMojave-cursors.tar.xz -C /usr/share/icons
fi

if [ $displaymanager == "sddm" ]; then
	tar -xf $scriptdir/theme-files/displaymanager-$displaymanager/archlinux-themes-sddm.tar -C /usr/share/sddm/themes
fi

echo ""
echo "- Copy config files ... "
echo ""

cd $scriptdir/cfg-files/system/etc/skel
mv config/ .config/

cp -R -v $scriptdir/cfg-files/system/* /

if [ $displaymanager == "sddm" ]; then
	mkdir -p /etc/sddm.conf.d
	cp -R -v $scriptdir/cfg-files/displaymanager-$displaymanager/* /
fi

if [ $desktopenvironment == "i3" ]; then
	cd $scriptdir/cfg-files/desktopenvironment-$desktopenvironment/etc/skel
	mv gtkrc-2.0 .gtkrc-2.0
	mv config/ .config/
	mv icons/ .icons/

	cp -R -v $scriptdir/cfg-files/desktopenvironment-$desktopenvironment/* /
fi

if [ $desktopenvironment == "kde" ]; then
	cd $scriptdir/cfg-files/desktopenvironment-$desktopenvironment/etc/skel
	mv config/ .config/

	cp -R -v $scriptdir/cfg-files/desktopenvironment-$desktopenvironment/* /
fi

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
echo "- Setting up sudo without no password rights for users ... "
echo ""

sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

echo ""
echo "- Adding user $username ... "
echo ""

useradd -m -g users -G audio,games,lp,optical,power,scanner,storage,video,wheel,vboxusers -s /bin/bash $username
echo "${username}:${password}" | chpasswd
cp -R -v $scriptdir /home/$username
chown -R $username:users /home/$username/arch-linux-install

echo ""