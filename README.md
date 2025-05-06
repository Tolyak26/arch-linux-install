# arch-linux-install
Мои скрипты для установки Arch Linux

----

https://wiki.archlinux.org/title/Iwd#Connect_to_a_network

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
cfdisk -z /dev/sda -> Table type "dos" (MBR) или "gpt"

BIOS dos (MBR):

Mount point "/" -> Device "/dev/sda1" -> Boot "*" -> Type "Linux" -> All disk space


BIOS gpt:

No mount point -> Device "/dev/sda1" -> Type "BIOS Boot" -> Size "1 Mb"

Mount point "/" -> Device "/dev/sda2" -> Type "Linux filesystem" -> All disk space


UEFI dos (MBR):

Mount point "/boot" or "/efi" -> Device "/dev/sda1" -> Type "EFI (FAT12/16/32)" -> Size "1 Gb"

Mount point "/" -> Device "/dev/sda2" -> Type "Linux" -> All disk space


UEFI gpt:

Mount point "/boot" or "/efi" -> Device "/dev/sda1" -> Type "EFI System" -> Size "1 Gb"

Mount point "/" -> Device "/dev/sda2" -> Type "Linux filesystem" -> All disk space
```

----

```
BIOS MBR:

mkfs.ext4 /dev/sda1


BIOS GPT:

mkfs.ext4 /dev/sda2


UEFI MBR:

mkfs.fat -F32 /dev/sda1

mkfs.ext4 /dev/sda2


UEFI GPT:

mkfs.fat -F32 /dev/sda1
mkfs.fat -F32 /dev/mmcblk1p1

mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/mmcblk1p2
```

----

```
BIOS MBR:

mount /dev/sda1 /mnt


BIOS GPT:

mount /dev/sda2 /mnt


UEFI MBR:

mount /dev/sda2 /mnt

mount --mkdir /dev/sda1 /mnt/boot


UEFI GPT:

mount /dev/sda2 /mnt

mount --mkdir /dev/sda1 /mnt/boot

----

mount /dev/mmcblk1p2 /mnt

mount --mkdir /dev/mmcblk1p1 /mnt/boot
```
