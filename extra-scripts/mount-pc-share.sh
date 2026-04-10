#!/bin/bash

# ================= НАСТРОЙКИ =================
# Формат:
# "//server/share:/mnt/point:mount-label:/path/to/credentials"
LOCAL_SHARES=(
    "/dev/sdb1:/mnt/sdb1:ntfs:ssd_ntfs_2_2tb"
    "/dev/nvme0n1p1:/mnt/nvme0n1p1:ext4:nvme_ext4_3_2tb"
)

FSTAB="/etc/fstab"
FSTAB_BACKUP="/etc/fstab.backup_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="/var/log/local-mount.log"

CREATED_CREDS=()
ADDED_MOUNTS=()

# ================= ФУНКЦИИ =================
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOG_FILE"
}

rollback() {
    log "❌ Ошибка. Выполняю rollback"

    cp "$FSTAB_BACKUP" "$FSTAB"

    for MP in "${ADDED_MOUNTS[@]}"; do
        umount -f "$MP" &>/dev/null
    done

    for C in "${CREATED_CREDS[@]}"; do
        rm -f "$C"
    done

    log "✔ Rollback завершён"
    exit 1
}

# ================= ПРОВЕРКИ =================
if [ "$EUID" -ne 0 ]; then
    echo "Запусти скрипт через sudo"
    exit 1
fi

touch "$LOG_FILE" || {
    echo "Не могу писать в $LOG_FILE"
    exit 1
}

log "===== Запуск настройки локальных точек монтирования ====="

cp "$FSTAB" "$FSTAB_BACKUP" || {
    log "❌ Не удалось создать backup fstab"
    exit 1
}
log "✔ Backup fstab: $FSTAB_BACKUP"

# ================= ОСНОВНОЙ ЦИКЛ =================
for ENTRY in "${LOCAL_SHARES[@]}"; do
    LOCAL_SHARE="$(echo "$ENTRY" | cut -d: -f1)"
    MOUNT_POINT="$(echo "$ENTRY" | cut -d: -f2)"
    MOUNT_FS_TYPE="$(echo "$ENTRY" | cut -d: -f3)"
    MOUNT_LABEL="$(echo "$ENTRY" | cut -d: -f4)"

    log "▶ Обработка $LOCAL_SHARE"
    log "  Точка:  $MOUNT_POINT"
    log "  Файл. система:  $MOUNT_FS_TYPE"

    mkdir -p "$MOUNT_POINT"

    echo

    if grep -qE "^[^#]*[[:space:]]+$MOUNT_POINT[[:space:]]+" "$FSTAB"; then
        log "⚠ Запись в fstab уже существует, пропуск"
        continue
    fi

    if [ $MOUNT_FS_TYPE == "ntfs" ]; then
        echo "$LOCAL_SHARE $MOUNT_POINT $MOUNT_FS_TYPE uid=tolyak26,gid=users,nofail,x-gvfs-show,x-gvfs-name=$MOUNT_LABEL 0 0" >> "$FSTAB"
    fi

    if [ $MOUNT_FS_TYPE == "ext4" ]; then
        echo "$LOCAL_SHARE $MOUNT_POINT $MOUNT_FS_TYPE rw,relatime,nofail,x-gvfs-show,x-gvfs-name=$MOUNT_LABEL 0 0" >> "$FSTAB"
    fi

    ADDED_MOUNTS+=("$MOUNT_POINT")
    log "✔ Добавлено в fstab"
done

# ================= МОНТИРОВАНИЕ =================
log "▶ Выполняю mount -a"
systemctl daemon-reload
if ! mount -a; then
    rollback
fi

for MP in "${ADDED_MOUNTS[@]}"; do
    if ! mountpoint -q "$MP"; then
        log "❌ $MP не смонтировано"
        rollback
    fi
    log "✔ $MP смонтировано"
done

log "===== Все локальные точки монтирования успешно настроены ====="
