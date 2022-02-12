#!/bin/bash

# Получение пути каталога скрипта
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo -ne "Импорт настроек из конфигурационного файла setup.conf"
echo -ne ""
source $SCRIPT_DIR/setup.conf

echo -ne "Запуск предварительного скрипта установки 01-pre-setup.sh"
echo -ne ""
bash 01-pre-setup.sh

echo -ne "Запуск скрипта 02-setup.sh в root каталоге /"
echo -ne ""
arch-chroot /mnt /root/arch-linux-install/02-setup.sh

echo -ne "Запуск скрипта 03-user.sh в каталоге пользователя $USERNAME"
echo -ne ""
arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/arch-linux-install/03-user.sh

echo -ne "Запуск скрипта 04-post-setup.sh в root каталоге /"
echo -ne ""
arch-chroot /mnt /root/arch-linux-install/04-post-setup.sh
