#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

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
curl -fSs https://api.github.com/repos/pineappleEA/pineapple-src/releases/latest | grep "browser_download_url" | grep -E "Linux-Yuzu-EA-(.*).AppImage" | head -1 | cut -d '"' -f 4 | wget -O /appimages/yuzu-ea.AppImage -i -
chmod +x /appimages/yuzu-ea.AppImage

# yuzu mainline
curl -fSs https://api.github.com/repos/yuzu-emu/yuzu-mainline/releases/latest | grep "browser_download_url" | grep -E "yuzu-mainline-(.*)-(.*).AppImage" | head -1 | cut -d '"' -f 4 | wget -O /appimages/yuzu-mainline.AppImage -i -
chmod +x /appimages/yuzu-mainline.AppImage

# MoonDeckBuddy
curl -fSs https://api.github.com/repos/FrogTheFrog/moondeck-buddy/releases/latest | grep "browser_download_url" | grep -E "MoonDeckBuddy-(.*)-x86_64.AppImage" | head -1 | cut -d '"' -f 4 | wget -O /appimages/moondeckbuddy.AppImage -i -
chmod +x /appimages/moondeckbuddy.AppImage

chown -R $username:users /appimages

### Installing AppImage's - Done ###

echo ""
