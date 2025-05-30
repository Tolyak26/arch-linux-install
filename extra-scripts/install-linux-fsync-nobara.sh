#!/usr/bin/env bash

# Script
# by
# Tolyak26
# URL: github.com/Tolyak26/arch-linux-install

echo ""
echo "- Installing linux-fsync-nobara binary packages from AUR ... "
echo ""

yay -S --answeredit N --answerclean N --answerdiff N --answerupgrade Y --noconfirm --needed --removemake --mflags "--skippgpcheck" linux-fsync-nobara-bin

sleep 1
echo ""
echo "- Updating /boot/grub/grub.cfg ... "
echo ""

sudo grub-mkconfig -o /boot/grub/grub.cfg
