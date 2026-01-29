#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo ""
echo "- Installing linux-xanmod-x64v3 binary packages for Zen3 from AUR ... "
echo ""

#yay -S --answeredit N --answerclean N --answerdiff N --answerupgrade Y --noconfirm --needed --removemake --mflags "--skippgpcheck" linux-xanmod-linux-bin-x64v3 linux-xanmod-linux-headers-bin-x64v3

gpg --keyserver hkps://pgp.surf.nl --recv-keys ABAF11C65A2970B130ABE3C479BE3E4300411886

yay -S --noconfirm --needed --removemake linux-xanmod-linux-bin-x64v3 linux-xanmod-linux-headers-bin-x64v3

sleep 1
echo ""
echo "- Updating /boot/grub/grub.cfg ... "
echo ""

sudo grub-mkconfig -o /boot/grub/grub.cfg
