#!/usr/bin/env bash
# Sauvegarde la base de données (via le conteneur docker-compose) et
# conserve les 7 derniers jours de sauvegardes.
#
# À planifier avec cron, ex :
#   0 4 * * * /chemin/vers/deploy/backup-db.sh >> /var/log/gta-rp-backup.log 2>&1

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$ROOT_DIR/backups"
mkdir -p "$BACKUP_DIR"

set -a
source "$ROOT_DIR/.env"
set +a

STAMP="$(date +%Y-%m-%d_%H-%M-%S)"
FILE="$BACKUP_DIR/${DB_NAME}_$STAMP.sql.gz"

docker exec gta-rp-db mysqldump -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" | gzip > "$FILE"
echo "Sauvegarde créée : $FILE"

find "$BACKUP_DIR" -name '*.sql.gz' -mtime +7 -delete
