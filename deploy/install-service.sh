#!/usr/bin/env bash
# Installe et démarre le serveur GTA RP en tant que service systemd
# (redémarrage automatique en cas de crash).
#
# Usage : ./deploy/install-service.sh [utilisateur-linux]

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVICE_NAME="gta-rp"
RUN_USER="${1:-$(whoami)}"

if [ ! -d "$ROOT_DIR/fxserver" ]; then
  echo "fxserver/ introuvable, lance d'abord ./setup.sh"
  exit 1
fi

sed -e "s#{{WORKDIR}}#$ROOT_DIR/fxserver#g" \
    -e "s#{{CFG}}#$ROOT_DIR/server-data/server.cfg#g" \
    -e "s#{{USER}}#$RUN_USER#g" \
    "$ROOT_DIR/deploy/gta-rp.service.tpl" | sudo tee "/etc/systemd/system/$SERVICE_NAME.service" > /dev/null

sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"

echo "Service '$SERVICE_NAME' installé et démarré."
echo "Logs en direct : journalctl -u $SERVICE_NAME -f"
