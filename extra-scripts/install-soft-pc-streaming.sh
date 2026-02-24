#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

if [ -z "${username}" ]; then
	username="$(id -un)"
fi

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

sudo pacman -S --noconfirm --disable-download-timeout --needed ydotool

sudo pacman -S --noconfirm --disable-download-timeout --needed lizardbyte/sunshine

sudo cp -v /usr/share/applications/dev.lizardbyte.app.Sunshine.desktop /home/${username}/.config/autostart
sudo sed -i 's/^Terminal=true/Terminal=false/' /home/${username}/.config/autostart/dev.lizardbyte.app.Sunshine.desktop
sudo curl -sSL https://raw.githubusercontent.com/Tolyak26/arch-linux-install/refs/heads/master/cfg-files/desktopenvironment-kde/etc/skel/config/sunshine/apps.json -o /home/${username}/.config/sunshine/apps.json

sudo usermod -aG input ${username}

systemctl --user enable ydotool.service
systemctl --user start ydotool.service
##

## MoonDeckBuddy
sudo mkdir -p /opt/MoonDeckBuddy-appimage/

curl -fSs https://api.github.com/repos/FrogTheFrog/moondeck-buddy/releases/latest | grep "browser_download_url" | grep -E "MoonDeckBuddy-(.*)-x86_64.AppImage" | head -1 | cut -d '"' -f 4 | sudo wget -O /opt/MoonDeckBuddy-appimage/MoonDeckBuddy.AppImage -i -
sudo chmod +x /opt/MoonDeckBuddy-appimage/MoonDeckBuddy.AppImage

sudo curl -sSL https://raw.githubusercontent.com/FrogTheFrog/moondeck-buddy/main/resources/icons/app-16.png -o /usr/share/icons/hicolor/16x16/apps/MoonDeckBuddy.png
sudo curl -sSL https://raw.githubusercontent.com/FrogTheFrog/moondeck-buddy/main/resources/icons/app-32.png -o /usr/share/icons/hicolor/32x32/apps/MoonDeckBuddy.png
sudo curl -sSL https://raw.githubusercontent.com/FrogTheFrog/moondeck-buddy/main/resources/icons/app-64.png -o /usr/share/icons/hicolor/64x64/apps/MoonDeckBuddy.png
sudo curl -sSL https://raw.githubusercontent.com/FrogTheFrog/moondeck-buddy/main/resources/icons/app-128.png -o /usr/share/icons/hicolor/128x128/apps/MoonDeckBuddy.png
sudo curl -sSL https://raw.githubusercontent.com/FrogTheFrog/moondeck-buddy/main/resources/icons/app-256.png -o /usr/share/icons/hicolor/256x256/apps/MoonDeckBuddy.png

sudo curl -sSL https://raw.githubusercontent.com/Tolyak26/arch-linux-install/refs/heads/master/desktop-files/MoonDeckBuddy.desktop -o /usr/share/applications/MoonDeckBuddy.desktop
##
