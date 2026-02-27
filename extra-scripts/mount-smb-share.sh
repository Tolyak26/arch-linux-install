#!/bin/bash

# ================= НАСТРОЙКИ =================
# Формат:
# "//server/share:/mnt/point:mount-label:/path/to/credentials"
SMB_SHARES=(
    "//192.168.1.15/ntfs_1_2tb:/mnt/smb_ntfs_1_2tb:smb_ntfs_1_2tb:/root/.smb_cred_share1"
    "//192.168.1.15/ntfs_2_4tb:/mnt/smb_ntfs_2_4tb:smb_ntfs_2_4tb:/root/.smb_cred_share2"
    "//192.168.1.15/ntfs_3_2tb:/mnt/smb_ntfs_3_2tb:smb_ntfs_3_2tb:/root/.smb_cred_share3"
)

FS_TYPE="cifs"
#SMB_VERS="3.0"
#COMMON_OPTS="iocharset=utf8,rw,vers=$SMB_VERS,_netdev,nofail"

FSTAB="/etc/fstab"
FSTAB_BACKUP="/etc/fstab.backup_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="/var/log/smb-mount.log"

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

check_server() {
    local SERVER="$1"

    log "Проверка доступности сервера: $SERVER"

    if ! ping -c 1 -W 2 "$SERVER" &>/dev/null; then
        log "❌ Сервер $SERVER недоступен (ping)"
        return 1
    fi

    log "✔ Сервер $SERVER доступен"
    return 0
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

log "===== Запуск настройки SMB ====="

cp "$FSTAB" "$FSTAB_BACKUP" || {
    log "❌ Не удалось создать backup fstab"
    exit 1
}
log "✔ Backup fstab: $FSTAB_BACKUP"

# ================= ОСНОВНОЙ ЦИКЛ =================
for ENTRY in "${SMB_SHARES[@]}"; do
    SMB_SHARE="$(echo "$ENTRY" | cut -d: -f1)"
    MOUNT_POINT="$(echo "$ENTRY" | cut -d: -f2)"
    MOUNT_LABEL="$(echo "$ENTRY" | cut -d: -f3)"
    CRED_FILE="$(echo "$ENTRY" | cut -d: -f4)"

    SERVER="$(echo "$SMB_SHARE" | sed -E 's#//([^/]+)/.*#\1#')"

    log "▶ Обработка $SMB_SHARE"
    log "  Сервер: $SERVER"
    log "  Точка:  $MOUNT_POINT"

    check_server "$SERVER" || rollback

    mkdir -p "$MOUNT_POINT"

    read -p "  SMB login for $SMB_SHARE: " SMB_USER
    read -s -p "  SMB password: " SMB_PASS
    echo

    cat > "$CRED_FILE" <<EOF
username=$SMB_USER
password=$SMB_PASS
EOF
    chmod 600 "$CRED_FILE"
    CREATED_CREDS+=("$CRED_FILE")

    if grep -qE "^[^#]*[[:space:]]+$MOUNT_POINT[[:space:]]+" "$FSTAB"; then
        log "⚠ Запись в fstab уже существует, пропуск"
        continue
    fi

    echo "$SMB_SHARE $MOUNT_POINT $FS_TYPE credentials=$CRED_FILE,uid=$SMB_USER,gid=users,_netdev,nofail,x-gvfs-show,x-gvfs-name=$MOUNT_LABEL 0 0" >> "$FSTAB"
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

log "===== Все SMB-шары успешно настроены ====="
