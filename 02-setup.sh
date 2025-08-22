#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

set -x

script="$( readlink -f "${BASH_SOURCE[0]}" )"
scriptdir="$( dirname "$script" )"

cd "$scriptdir" || exit 1

### Import settings from setup.conf
source $scriptdir/setup.conf

### Optimizing pacman for optimal download - Start ###

echo ""
echo "- Optimizing pacman for optimal download ... "
echo ""

#pacman -S --noconfirm --needed python3 reflector
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
#reflector --country Russia --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
echo 'Server = https://mirror.yandex.ru/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
echo 'Server = https://mirror.yandex.ru/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
echo 'Server = https://mirror.truenetwork.ru/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
pacman -Sy --noconfirm

### Optimizing pacman for optimal download - Done ###

### Optimizing makeflags configuration for your CPU - Start ###

echo ""
echo "- Optimizing makeflags configuration for your CPU ... "
echo ""

get_cpu_core_count=$(grep -c ^processor /proc/cpuinfo)
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$get_cpu_core_count\"/g" /etc/makepkg.conf
sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $get_cpu_core_count -z -)/g" /etc/makepkg.conf

### Optimizing makeflags configuration for your CPU - Done ###

### Installing additional packages for Arch Linux system - Start ###

echo ""
echo "- Installing additional packages for Arch Linux system ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-arch-additional.txt

### Installing additional packages for Arch Linux system - Done ###

### Installing NetworkManager packages - Start ###

echo ""
echo "- Installing NetworkManager packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-networkmanager.txt

### Installing NetworkManager packages - Done ###

### Installing microcode packages for CPU - Start ###

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

### Installing microcode packages for CPU - Done ###

### Installing Xorg packages - Start ###

echo ""
echo "- Installing Xorg packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-xorg.txt

### Installing Xorg packages - Done ###

### Installing Wayland packages - Start ###

echo ""
echo "- Installing Wayland packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-wayland.txt

### Installing Wayland packages - Done ###

### Installing driver packages for GPU - Start ###

echo ""
echo "- Installing driver packages for GPU ... "
echo ""

if [[ $graphicscard == "nvidia" ]]; then
	echo "Installing NVIDIA packages"
	pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-video-nvidia.txt
	sed -i 's/^MODULES=()/MODULES=(nvidia)/' /etc/mkinitcpio.conf
	nvidia-xconfig
elif [[ $graphicscard == "ati" ]]; then
	echo "Installing ATI Legacy packages"
	pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-video-ati.txt
	sed -i 's/^MODULES=()/MODULES=(radeon)/' /etc/mkinitcpio.conf
elif [[ $graphicscard == "amd" ]]; then
	echo "Installing AMDGPU packages"
	pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-video-amd.txt
	sed -i 's/^MODULES=()/MODULES=(amdgpu)/' /etc/mkinitcpio.conf
elif [[ $graphicscard == "intel" ]]; then
	echo "Installing Intel packages"
	pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-video-intel.txt
	sed -i 's/^MODULES=()/MODULES=(i915)/' /etc/mkinitcpio.conf
fi

### Installing driver packages for GPU - Done ###

### Installing packages for Virtual Machine Environment - Start ###

echo ""
echo "- Installing packages for Virtual Machine Environment ... "
echo ""

get_vm_product=$(/usr/bin/dmidecode -t system | grep -E 'Product Name:' | awk '{split ($0, a, ": "); print a[2]}')
if grep -E "VirtualBox" <<< ${get_vm_product}; then
	echo "Installing VirtualBox packages"
	pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-vm-virtualbox.txt
	systemctl enable vboxservice.service
elif grep -E "VMware" <<< ${get_vm_product}; then
	echo "Installing VMWare packages"
	pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-vm-vmware.txt
	systemctl enable vmtoolsd.service vmware-vmblock-fuse.service
fi

### Installing packages for Virtual Machine Environment - Done ###

### Installing ALSA packages for Sound hardware - Start ###

echo ""
echo "- Installing ALSA packages for Sound hardware ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-sound-alsa.txt

### Installing ALSA packages for Sound hardware - Done ###

### Installing PulseAudio packages for Sound hardware - Start ###

if [[ $soundserver == "pulseaudio" ]] || [[ $soundserver == "pulse" ]]; then
	echo ""
	echo "- Installing PulseAudio packages for Sound hardware ... "
	echo ""

	pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-sound-server-pulseaudio.txt
fi

### Installing PulseAudio packages for Sound hardware - Done ###

### Installing PipeWire packages for Sound hardware - Start ###

if [[ $soundserver == "pipewire" ]]; then
	echo ""
	echo "- Installing PipeWire packages for Sound hardware ... "
	echo ""

	pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-sound-server-pipewire.txt
fi

### Installing PipeWire packages for Sound hardware - Done ###

### Installing packages for Bluetooth hardware - Start ###

echo ""
echo "- Installing packages for Bluetooth hardware ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-driver-bluetooth.txt

### Installing packages for Bluetooth hardware - Done ###

### Generating mkinitcpio - Start ###

echo ""
echo "- Generating mkinitcpio ... "
echo ""

mkinitcpio -P

### Generating mkinitcpio - Done ###

### Installing Bootloader packages - Start ###

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

### Installing Bootloader packages - Done ###

### Installing Display Manager packages - Start ###

echo ""
echo "- Installing Display Manager packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-displaymanager-$displaymanager.txt

### Installing Display Manager packages - Done ###

### Installing Desktop Environment packages - Start ###

echo ""
echo "- Installing Desktop Environment packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-desktopenvironment-$desktopenvironment.txt

### Installing Desktop Environment packages - Done ###

### Installing Samba packages - Start ###

echo ""
echo "- Installing Samba packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-samba.txt

### Installing Samba packages - Done ###

### Installing Media Codec packages - Start ###

echo ""
echo "- Installing Media Codec packages ... "
echo ""

pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-media-codecs.txt

### Installing Media Codec packages - Done ###

### Installing User Software packages - Start ###

#echo ""
#echo "- Installing User Software packages ... "
#echo ""

#pacman -S --noconfirm --needed - < $scriptdir/pkg-lists/pkg-user-soft.txt

### Installing User Software packages - Done ###

### Installing theme files - Start ###

echo ""
echo "- Installing theme files ... "
echo ""

if [ $desktopenvironment == "i3" ]; then
	tar -xvf $scriptdir/theme-files/icons/McMojave-cursors.tar.xz -C /usr/share/icons
fi

if [ $displaymanager == "sddm" ]; then
	tar -xvf $scriptdir/theme-files/displaymanager-$displaymanager/archlinux-themes-sddm.tar -C /usr/share/sddm/themes
fi

### Installing theme files - Done ###

### Copying config files - Start ###

echo ""
echo "- Copying config files ... "
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
 	mv gtkrc-2.0 .gtkrc-2.0
	mv config/ .config/

	cp -R -v $scriptdir/cfg-files/desktopenvironment-$desktopenvironment/* /
fi

### Copying config files - Done ###

### Setting up system locale and timezone - Start ###

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

### Setting up system locale and timezone - Done ###

### Setiing up /etc/hosts & /etc/hostname - Start ###

echo ""
echo "- Setiing up /etc/hosts & /etc/hostname ... "
echo ""

tee -a /etc/hosts << EOF
127.0.0.1        localhost
::1              localhost
127.0.1.1        $nameofmachine
EOF

echo $nameofmachine > /etc/hostname

### Setiing up /etc/hosts & /etc/hostname - Done ###

### Setting up sudo without no password rights for users - Start ###

echo ""
echo "- Setting up sudo without no password rights for users ... "
echo ""

sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

### Setting up sudo without no password rights for users - Done ###

### Adding user - Start ###

echo ""
echo "- Adding user $username ... "
echo ""

useradd -m -g users -G audio,games,lp,optical,power,scanner,storage,video,wheel -s /bin/bash $username
echo "${username}:${password}" | chpasswd
cp -R -v $scriptdir /home/$username
chown -R $username:users /home/$username/arch-linux-install

### Adding user - Done ###

echo ""
