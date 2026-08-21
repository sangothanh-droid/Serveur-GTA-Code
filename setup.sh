#!/usr/bin/env bash
# Installe FXServer (dernière version recommandée) et les ressources QBCore
# nécessaires pour un serveur GTA RP en accès libre.
#
# Usage : ./setup.sh
# Prérequis : curl, tar, git

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FX_DIR="$ROOT_DIR/fxserver"
RESOURCES_DIR="$ROOT_DIR/server-data/resources"

command -v curl >/dev/null || { echo "curl est requis"; exit 1; }
command -v git  >/dev/null || { echo "git est requis"; exit 1; }
command -v tar  >/dev/null || { echo "tar est requis"; exit 1; }

echo "==> Récupération de la dernière version recommandée de FXServer (Linux)"
RECOMMENDED_JSON="$(curl -fsSL https://changelogs-live.fivem.net/api/changelog/versions/linux/server)"
ARTIFACT_URL="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$(
  echo "$RECOMMENDED_JSON" | grep -o '"recommended":[0-9]*' | grep -o '[0-9]*'
)/fx.tar.xz"

mkdir -p "$FX_DIR"
echo "==> Téléchargement de FXServer depuis $ARTIFACT_URL"
curl -fsSL "$ARTIFACT_URL" -o "$FX_DIR/fx.tar.xz"
tar -xf "$FX_DIR/fx.tar.xz" -C "$FX_DIR"
rm "$FX_DIR/fx.tar.xz"

echo "==> Clonage des ressources standalone"
mkdir -p "$RESOURCES_DIR/[standalone]"
[ -d "$RESOURCES_DIR/[standalone]/oxmysql" ] || \
  git clone --depth 1 https://github.com/overextended/oxmysql.git "$RESOURCES_DIR/[standalone]/oxmysql"

echo "==> Clonage du framework QBCore et des ressources de base"
mkdir -p "$RESOURCES_DIR/[qb]"
QB_RESOURCES=(
  qb-core
  qb-multicharacter
  qb-spawn
  qb-apartments
  qb-inventory
  qb-menu
  qb-input
  qb-hud
  qb-radialmenu
  qb-weathersync
)
for repo in "${QB_RESOURCES[@]}"; do
  target="$RESOURCES_DIR/[qb]/$repo"
  if [ -d "$target" ]; then
    echo "   - $repo déjà présent, skip"
  else
    echo "   - clonage de $repo"
    git clone --depth 1 "https://github.com/qbcore-framework/$repo.git" "$target"
  fi
done

cat <<'EOF'

==> Installation terminée.

Étapes restantes :
  1. Copier .env.example vers .env et renseigner les valeurs (DB, clé FiveM, clé Steam).
  2. Éditer server-data/server.cfg (licence, admin, nom du serveur).
  3. Démarrer la base de données : docker compose up -d
  4. Importer le schéma SQL de qb-core (voir server-data/resources/[qb]/qb-core) dans la base.
  5. Lancer le serveur :
       cd fxserver
       ./run.sh +exec ../server-data/server.cfg
EOF
