# Serveur-GTA-Code

Configuration et scripts d'installation pour un serveur **GTA V Roleplay** sur
[FiveM](https://fivem.net/), en **accès libre** (aucune whitelist), basé sur le
framework [QBCore](https://github.com/qbcore-framework).

## Contenu du repo

| Fichier / dossier          | Rôle                                                        |
|-----------------------------|--------------------------------------------------------------|
| `server-data/server.cfg.example` | Template de configuration FXServer (versionné, sans secrets) |
| `server-data/server.cfg`    | Configuration réelle (créée par `setup.sh`, **non versionnée**, contient ta licence FiveM et ton identifiant admin) |
| `docker-compose.yml`        | Base de données MariaDB + Adminer                            |
| `.env.example`               | Modèle des variables d'environnement (à copier en `.env`)   |
| `setup.sh`                   | Télécharge FXServer et clone les ressources QBCore           |
| `server-data/resources/[local]/rp-loadingscreen` | Écran de chargement personnalisé (NUI HTML/CSS/JS pur, sans asset binaire) |
| `server-data/resources/[local]/rp-scoreboard` | Scoreboard NUI : liste des joueurs connectés (nom, ID, ping) en maintenant TAB |
| `server-data/resources/[local]/rp-queue`    | File d'attente FIFO (avec priorité staff) quand le serveur est plein |
| `server-data/resources/[local]/rp-welcome`  | Écran de règlement à l'arrivée + logs Discord (join/leave)   |
| `server-data/resources/[local]/rp-gangs`    | Réputation de gang avec conséquences (police, économie)      |
| `server-data/resources/[local]/rp-crime-core` | Helpers partagés (argent, gang, alerte police) pour les activités criminelles |
| `server-data/resources/[local]/rp-shoprobbery`, `rp-carjack`, `rp-drugdealing`, `rp-illegalrace`, `rp-laundering`, `rp-heist`, `rp-armstrafficking`, `rp-turfwar`, `rp-weedfarm`, `rp-weaponlab`, `rp-druglab`, `rp-atmrobbery`, `rp-bountyhunter` | 13 activités criminelles jouables, voir `docs/CRIME-JOBS.md` |
| `server-data/resources/[local]/rp-labwars`  | Guerre de monopole sur les labos d'armes/drogue (contrôle de territoire) |
| `server-data/resources/[local]/rp-gangwar-events` | Point chaud périodique (toutes les 3h) sur un territoire de gang aléatoire, annoncé chat + Discord |
| `server-data/resources/[local]/rp-streetrep`, `rp-pettycrime`, `rp-soloburglary`, `rp-lonewolfcarjack` | Petites frappes solo (hors gangs officiels), système parallèle à `rp-gangs`, voir `docs/SOLO-CRIME.md` |
| `server-data/resources/[local]/rp-job-core`, `rp-mechanic`, `rp-security`, `rp-realestate`, `rp-taxi`, `rp-delivery`, `rp-garbage`, `rp-lumberjack`, `rp-fisherman`, `rp-postal`, `rp-busker`, `rp-carwash`, `rp-police`, `rp-ambulance`, `rp-firefighter`, `rp-restaurant`, `rp-barber`, `rp-nightclub` | 17 jobs légaux jouables, voir `docs/LEGAL-JOBS.md` |
| `server-data/resources/[local]/rp-casino`, `rp-carmeet` | Divertissement/social ouverts à tous (mini-jeux de mise, rassemblement voitures), voir `docs/LEGAL-JOBS.md` |
| `server-data/resources/[local]/rp-lasergame`, `rp-arcade` | Loisirs ouverts à tous (laser game entre joueurs, bornes d'arcade), voir `docs/ACTIVITIES.md` |
| `server-data/resources/[addons]/`           | Templates pour véhicules/armes/maps additionnels (assets à fournir) |
| `deploy/install-service.sh` | Installe le serveur comme service systemd (auto-restart)     |
| `deploy/firewall.sh`         | Configure UFW (ports 22, 30120, 40120 uniquement)             |
| `deploy/backup-db.sh`        | Sauvegarde + rotation de la base de données                   |
| `docs/INSTALL.md`            | Guide d'installation pas à pas                                |
| `docs/SOLO-CRIME.md`         | Petites frappes solo hors gangs officiels (réputation de rue) |
| `docs/ACTIVITIES.md`         | Loisirs et casino étendu (mini-jeux, laser game, arcade)      |

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
