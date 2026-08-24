#!/usr/bin/env bash
# Installe FXServer (dernière version recommandée) et les ressources QBCore
# nécessaires pour un serveur GTA RP en accès libre.
#
# Usage : ./setup.sh
# Prérequis : curl, tar, git, unzip

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FX_DIR="$ROOT_DIR/fxserver"
RESOURCES_DIR="$ROOT_DIR/server-data/resources"

command -v curl  >/dev/null || { echo "curl est requis"; exit 1; }
command -v git   >/dev/null || { echo "git est requis"; exit 1; }
command -v tar   >/dev/null || { echo "tar est requis"; exit 1; }
command -v unzip >/dev/null || { echo "unzip est requis"; exit 1; }

echo "==> Récupération de la dernière version recommandée de FXServer (Linux)"
RECOMMENDED_JSON="$(curl -fsSL https://changelogs-live.fivem.net/api/changelog/versions/linux/server)"
ARTIFACT_URL="$(echo "$RECOMMENDED_JSON" | grep -o '"recommended_download":"[^"]*"' | cut -d'"' -f4)"

[ -n "$ARTIFACT_URL" ] || { echo "Impossible de déterminer l'URL de FXServer (réponse API inattendue)"; exit 1; }

mkdir -p "$FX_DIR"
echo "==> Téléchargement de FXServer depuis $ARTIFACT_URL"
curl -fsSL "$ARTIFACT_URL" -o "$FX_DIR/fx.tar.xz"
tar -xf "$FX_DIR/fx.tar.xz" -C "$FX_DIR"
rm "$FX_DIR/fx.tar.xz"

echo "==> Installation d'oxmysql (build officiel, PAS le dépôt source qui n'a pas de fxmanifest.lua)"
mkdir -p "$RESOURCES_DIR/[standalone]"
if [ ! -f "$RESOURCES_DIR/[standalone]/oxmysql/fxmanifest.lua" ]; then
  rm -rf "$RESOURCES_DIR/[standalone]/oxmysql"
  OXMYSQL_URL="$(curl -fsSL https://api.github.com/repos/overextended/oxmysql/releases/latest \
    | grep -o '"browser_download_url":"[^"]*oxmysql.zip"' | cut -d'"' -f4)"
  [ -n "$OXMYSQL_URL" ] || { echo "Impossible de déterminer l'URL de release d'oxmysql"; exit 1; }
  curl -fsSL "$OXMYSQL_URL" -o "$FX_DIR/oxmysql.zip"
  unzip -q -o "$FX_DIR/oxmysql.zip" -d "$RESOURCES_DIR/[standalone]"
  rm "$FX_DIR/oxmysql.zip"
fi

echo "==> Clonage du framework QBCore et des ressources de base"
mkdir -p "$RESOURCES_DIR/[qb]"
# qb-weapons : dépendance dure de qb-inventory (dependency 'qb-weapons').
# qb-interior, qb-clothing, PolyZone : dépendances dures de qb-apartments
# (voir dependencies{} dans son fxmanifest.lua).
QB_RESOURCES=(
  qb-core
  qb-multicharacter
  qb-spawn
  qb-apartments
  qb-interior
  qb-clothing
  qb-inventory
  qb-weapons
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
[ -d "$RESOURCES_DIR/[qb]/PolyZone" ] || \
  git clone --depth 1 https://github.com/qbcore-framework/PolyZone.git "$RESOURCES_DIR/[qb]/PolyZone"

echo "==> Récupération des ressources système FiveM (chat, spawnmanager, ...)"
# "ensure mapmanager/chat/spawnmanager/sessionmanager/baseevents/hardcap/rconlog"
# dans server.cfg suppose que ces ressources existent : elles ne sont PAS
# fournies par FXServer lui-même, il faut les récupérer depuis cfx-server-data.
mkdir -p "$RESOURCES_DIR/[system]"
if [ ! -f "$RESOURCES_DIR/[system]/chat/fxmanifest.lua" ]; then
  CFX_TMP="$(mktemp -d)"
  curl -fsSL https://github.com/citizenfx/cfx-server-data/archive/refs/heads/master.tar.gz -o "$CFX_TMP/cfx-server-data.tar.gz"
  tar -xzf "$CFX_TMP/cfx-server-data.tar.gz" -C "$CFX_TMP" \
    --wildcards \
    "*/resources/\[managers\]/mapmanager/*" \
    "*/resources/\[managers\]/spawnmanager/*" \
    "*/resources/\[system\]/baseevents/*" \
    "*/resources/\[system\]/hardcap/*" \
    "*/resources/\[system\]/rconlog/*" \
    "*/resources/\[system\]/sessionmanager/*" \
    "*/resources/\[gameplay\]/chat/*"
  CFX_SRC="$CFX_TMP"/cfx-server-data-*/resources
  for name in mapmanager spawnmanager; do
    cp -r "$CFX_SRC/[managers]/$name" "$RESOURCES_DIR/[system]/$name"
  done
  for name in baseevents hardcap rconlog sessionmanager; do
    cp -r "$CFX_SRC/[system]/$name" "$RESOURCES_DIR/[system]/$name"
  done
  cp -r "$CFX_SRC/[gameplay]/chat" "$RESOURCES_DIR/[system]/chat"
  rm -rf "$CFX_TMP"
fi

if [ ! -f "$ROOT_DIR/server-data/server.cfg" ]; then
  echo "==> Création de server-data/server.cfg à partir du template (non versionné, contient tes secrets)"
  cp "$ROOT_DIR/server-data/server.cfg.example" "$ROOT_DIR/server-data/server.cfg"
fi

cat <<'EOF'

==> Installation terminée.

Étapes restantes :
  1. Copier .env.example vers .env et renseigner les valeurs (DB, clé FiveM, clé Steam).
  2. Éditer server-data/server.cfg :
       - licence FiveM et identifiant admin (add_principal)
       - mysql_connection_string : mets les VRAIES valeurs de ton .env, FXServer
         n'interprète PAS la syntaxe ${DB_USER} dans un .cfg
     Ce fichier n'est PAS versionné (voir .gitignore), tes secrets restent sur ce serveur.
  3. Démarrer la base de données : docker compose up -d
  4. Importer TOUS les schémas SQL (pas seulement celui de qb-core) :
       find server-data/resources -iname '*.sql' ! -path '*/.git/*' ! -name migrate.sql
     (qb-core, qb-inventory, qb-apartments, qb-clothing, rp-gangs, rp-turfwar, rp-labwars, ...)
  5. Lancer le serveur. FXServer découvre le dossier resources/ relatif à son
     répertoire de travail : il faut lancer run.sh depuis server-data/, pas
     depuis fxserver/. Comme FXServer traite un stdin fermé comme un ordre
     d'arrêt, lance-le dans une session `screen` détachée pour qu'il tienne
     en arrière-plan :
       cd server-data
       screen -dmS gta-rp ../fxserver/run.sh +exec server.cfg
       screen -r gta-rp   # pour rouvrir la console (Ctrl+A puis D pour redétacher)
EOF
