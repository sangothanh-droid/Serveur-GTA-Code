# Serveur-GTA-Code

Configuration et scripts d'installation pour un serveur **GTA V Roleplay** sur
[FiveM](https://fivem.net/), en **accès libre** (aucune whitelist), basé sur le
framework [QBCore](https://github.com/qbcore-framework).

## Contenu du repo

| Fichier / dossier          | Rôle                                                        |
|-----------------------------|--------------------------------------------------------------|
| `server-data/server.cfg`    | Configuration principale du serveur FXServer                |
| `docker-compose.yml`        | Base de données MariaDB + Adminer                            |
| `.env.example`               | Modèle des variables d'environnement (à copier en `.env`)   |
| `setup.sh`                   | Télécharge FXServer et clone les ressources QBCore           |
| `docs/INSTALL.md`            | Guide d'installation pas à pas                                |

## Démarrage rapide

```bash
cp .env.example .env       # puis remplir les valeurs
docker compose up -d       # démarre la base de données
./setup.sh                 # installe FXServer + QBCore
cd fxserver && ./run.sh +exec ../server-data/server.cfg
```

Voir [`docs/INSTALL.md`](docs/INSTALL.md) pour le guide détaillé (licence
FiveM, import du schéma SQL, configuration admin, bonnes pratiques pour un
serveur en accès libre).
