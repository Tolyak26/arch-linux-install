#!/bin/bash

# Получение пути каталога скрипта
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo -ne "Импорт настроек из конфигурационного файла setup.conf"
source $SCRIPT_DIR/setup.conf

echo -ne "Запуск предварительного скрипта установки 01-pre-setup.sh"
bash 01-pre-setup.sh

echo -ne "Запуск скрипта 02-setup.sh в root каталоге /"
arch-chroot /mnt /root/arch-linux-install/02-setup.sh

echo -ne "Запуск скрипта 03-user.sh в каталоге пользователя $USERNAME"
arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/arch-linux-install/03-user.sh

echo -ne "Запуск скрипта 04-post-setup.sh в root каталоге /"
arch-chroot /mnt /root/arch-linux-install/04-post-setup.sh
