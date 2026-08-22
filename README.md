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
| `server-data/resources/[local]/rp-queue`    | File d'attente FIFO (avec priorité staff) quand le serveur est plein |
| `server-data/resources/[local]/rp-welcome`  | Écran de règlement à l'arrivée + logs Discord (join/leave)   |
| `server-data/resources/[local]/rp-gangs`    | Réputation de gang avec conséquences (police, économie)      |
| `server-data/resources/[local]/rp-crime-core` | Helpers partagés (argent, gang, alerte police) pour les activités criminelles |
| `server-data/resources/[local]/rp-shoprobbery`, `rp-carjack`, `rp-drugdealing`, `rp-illegalrace`, `rp-laundering`, `rp-heist`, `rp-armstrafficking`, `rp-turfwar`, `rp-weedfarm`, `rp-weaponlab`, `rp-druglab` | 11 activités criminelles jouables, voir `docs/CRIME-JOBS.md` |
| `server-data/resources/[local]/rp-labwars`  | Guerre de monopole sur les labos d'armes/drogue (contrôle de territoire) |
| `server-data/resources/[local]/rp-job-core`, `rp-mechanic`, `rp-security`, `rp-realestate`, `rp-taxi`, `rp-delivery`, `rp-garbage`, `rp-lumberjack`, `rp-fisherman`, `rp-postal`, `rp-busker` | 10 jobs légaux jouables, voir `docs/LEGAL-JOBS.md` |
| `server-data/resources/[addons]/`           | Templates pour véhicules/armes/maps additionnels (assets à fournir) |
| `deploy/install-service.sh` | Installe le serveur comme service systemd (auto-restart)     |
| `deploy/firewall.sh`         | Configure UFW (ports 22, 30120, 40120 uniquement)             |
| `deploy/backup-db.sh`        | Sauvegarde + rotation de la base de données                   |
| `docs/INSTALL.md`            | Guide d'installation pas à pas                                |

## Démarrage rapide

```bash
cp .env.example .env       # puis remplir les valeurs
docker compose up -d       # démarre la base de données
./setup.sh                 # installe FXServer + QBCore
./deploy/firewall.sh       # ouvre les ports nécessaires
./deploy/install-service.sh # démarre le serveur en service (auto-restart)
```

Voir [`docs/INSTALL.md`](docs/INSTALL.md) pour le guide détaillé (licence
FiveM, import du schéma SQL, configuration admin, bonnes pratiques pour un
serveur en accès libre).
