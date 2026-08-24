#!/usr/bin/env bash
# Configure UFW pour n'ouvrir que les ports nécessaires : SSH, FiveM, txAdmin.
set -euo pipefail

command -v ufw >/dev/null || { echo "ufw n'est pas installé (sudo apt install ufw)"; exit 1; }

sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 30120/tcp comment 'FiveM'
sudo ufw allow 30120/udp comment 'FiveM'
sudo ufw allow 40120/tcp comment 'txAdmin'
sudo ufw --force enable
sudo ufw status verbose
