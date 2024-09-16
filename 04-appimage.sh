#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

set -ex

script="$( readlink -f "${BASH_SOURCE[0]}" )"
scriptdir="$( dirname "$script" )"

cd "$scriptdir" || exit 1

### Import settings from setup.conf ###
source $scriptdir/setup.conf

### Installing AppImage's - Start ###

echo ""
echo "- Installing AppImage User Software ... "
echo ""

mkdir -p /appimages

# yuzu early access
#curl -fSs https://api.github.com/repos/pineappleEA/pineapple-src/releases/latest | grep "browser_download_url" | grep -E "Linux-Yuzu-EA-(.*).AppImage" | head -1 | cut -d '"' -f 4 | wget -O /appimages/yuzu-ea.AppImage -i -
#chmod +x /appimages/yuzu-ea.AppImage
#wget -O /usr/share/icons/hicolor/scalable/apps/yuzu-ea.svg https://raw.githubusercontent.com/pineappleEA/pineapple-src/main/dist/yuzu.svg
#cp -v $scriptdir/desktop-files/yuzu-ea.desktop /usr/share/applications

# yuzu mainline
#curl -fSs https://api.github.com/repos/yuzu-emu/yuzu-mainline/releases/latest | grep "browser_download_url" | grep -E "yuzu-mainline-(.*)-(.*).AppImage" | head -1 | cut -d '"' -f 4 | wget -O /appimages/yuzu-mainline.AppImage -i -
#chmod +x /appimages/yuzu-mainline.AppImage
#wget -O /usr/share/icons/hicolor/scalable/apps/yuzu-mainline.svg https://raw.githubusercontent.com/yuzu-emu/yuzu-mainline/master/dist/yuzu.svg
#cp -v $scriptdir/desktop-files/yuzu-mainline.desktop /usr/share/applications

# MoonDeckBuddy
curl -fSs https://api.github.com/repos/FrogTheFrog/moondeck-buddy/releases/latest | grep "browser_download_url" | grep -E "MoonDeckBuddy-(.*)-x86_64.AppImage" | head -1 | cut -d '"' -f 4 | wget -O /appimages/MoonDeckBuddy.AppImage -i -
chmod +x /appimages/MoonDeckBuddy.AppImage
wget -O /usr/share/icons/hicolor/16x16/apps/MoonDeckBuddy.png https://raw.githubusercontent.com/FrogTheFrog/moondeck-buddy/main/resources/icons/app-16.png
wget -O /usr/share/icons/hicolor/32x32/apps/MoonDeckBuddy.png https://raw.githubusercontent.com/FrogTheFrog/moondeck-buddy/main/resources/icons/app-32.png
wget -O /usr/share/icons/hicolor/64x64/apps/MoonDeckBuddy.png https://raw.githubusercontent.com/FrogTheFrog/moondeck-buddy/main/resources/icons/app-64.png
wget -O /usr/share/icons/hicolor/128x128/apps/MoonDeckBuddy.png https://raw.githubusercontent.com/FrogTheFrog/moondeck-buddy/main/resources/icons/app-128.png
wget -O /usr/share/icons/hicolor/256x256/apps/MoonDeckBuddy.png https://raw.githubusercontent.com/FrogTheFrog/moondeck-buddy/main/resources/icons/app-256.png
cp -v $scriptdir/desktop-files/MoonDeckBuddy.desktop /usr/share/applications

chown -R $username:users /appimages

### Installing AppImage's - Done ###

echo ""
