#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo ""
echo "- Installing packages for PC game streaming ... "
echo ""

## Sunshine
grep -q "^\[lizardbyte\]" /etc/pacman.conf || sudo tee -a /etc/pacman.conf > /dev/null <<'EOF'

[lizardbyte]
SigLevel = Optional
Server = https://github.com/LizardByte/pacman-repo/releases/latest/download
EOF

sudo pacman -Sy --noconfirm --disable-download-timeout

sudo pacman -S --noconfirm --disable-download-timeout --needed lizardbyte/sunshine

sudo cp -v /usr/share/applications/dev.lizardbyte.app.Sunshine.desktop /home/$username/.config/autostart
sudo sed -i 's/^Terminal=true/Terminal=false/' /home/$username/.config/autostart/dev.lizardbyte.app.Sunshine.desktop
##

