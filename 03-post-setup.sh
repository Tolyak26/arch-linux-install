#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

# Import settings from setup.conf
source /root/arch-linux-install/setup.conf

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

echo "- Enabling services ... "
echo ""
ntpd -qg
systemctl enable ntpd
systemctl enable cups
systemctl enable bluetooth
systemctl disable dhcpcd
systemctl stop dhcpcd
systemctl enable NetworkManager
echo ""

echo "- Setting up sudo without no password rights for users ... "
echo ""
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
echo ""

echo "- Setiing up /etc/hosts & /etc/hostname"
echo ""
tee -a /etc/hosts << EOF
127.0.0.1 localhost
::1 localhost
127.0.1.1 $nameofmachine.localdomain $nameofmachine
EOF
echo $nameofmachine > /etc/hostname
echo ""

echo "- Adding user $USERNAME"
echo ""
useradd -m -g users -G audio,games,lp,optical,power,scanner,storage,video,wheel -s /bin/bash $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd
rm -rf /home/$USERNAME/arch-linux-install
cp -R /root/arch-linux-install /home/$USERNAME/
chown -R $USERNAME: /home/$USERNAME/arch-linux-install
