# arch-linux-install
Мои скрипты для установки Arch Linux

----

```
pacman -Sy

pacman -S wget

wget -O install.sh tinyurl.com/arch-tolyak26

chmod +x install.sh

./install.sh
```

----

```
cfdisk -z /dev/sda - table - dos (MBR)/gpt

BIOS MBR (dos):

/boot - /dev/sda1 - Linux filesystem - 512 Mb

/ - /dev/sda2 - Linux filesystem - All disk space


BIOS GPT:

/boot - /dev/sda1 - BIOS Boot - 512 Mb

/ - /dev/sda2 - Linux filesystem - All disk space


UEFI MBR:

/boot or /efi - /dev/sda1 - EFI (FAT12/16/32) - 512 Mb

/ - /dev/sda2 - Linux filesystem - All disk space


UEFI GPT:

/boot or /efi - /dev/sda1 - EFI System - 512 Mb

/ - /dev/sda2 - Linux filesystem - All disk space
```

----

```
BIOS MBR:

mkfs.ext4 /dev/sda1

mkfs.ext4 /dev/sda2


BIOS GPT:

mkfs.ext4 /dev/sda1

mkfs.ext4 /dev/sda2


UEFI MBR:

mkfs.fat -F32 /dev/sda1

mkfs.ext4 /dev/sda2


UEFI GPT:

mkfs.fat -F32 /dev/sda1

mkfs.ext4 /dev/sda2
```

----

```
BIOS MBR:

mount /dev/sda2 /mnt

mkdir /mnt/boot

mount /dev/sda1 /mnt/boot


BIOS GPT:

mount /dev/sda2 /mnt

mkdir /mnt/boot

mount /dev/sda1 /mnt/boot


UEFI MBR:

mount /dev/sda2 /mnt

mkdir /mnt/boot

mount /dev/sda1 /mnt/boot


UEFI GPT:

mount /dev/sda2 /mnt

mkdir /mnt/boot

mount /dev/sda1 /mnt/boot
```
