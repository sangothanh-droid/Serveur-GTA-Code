# Guide d'installation

## Prérequis

- Un VPS/serveur dédié **Linux** (Debian/Ubuntu recommandé), 4 Go de RAM minimum, 2 vCPU.
- `git`, `curl`, `tar`, Docker + Docker Compose.
- Un compte [Keymaster FiveM](https://keymaster.fivem.net/) pour générer une **licence serveur**.
- (Optionnel mais conseillé) une [clé Steam Web API](https://steamcommunity.com/dev/apikey).
- Le port **30120** (TCP + UDP) ouvert sur le pare-feu.

## Étapes

1. **Cloner le repo sur le VPS**
   ```bash
   git clone <url-du-repo> gta-rp && cd gta-rp
   ```

2. **Configurer les variables d'environnement**
   ```bash
   cp .env.example .env
   nano .env   # remplir DB_PASSWORD, FIVEM_LICENSE_KEY, STEAM_WEB_API_KEY, etc.
   ```

3. **Lancer la base de données**
   ```bash
   docker compose up -d
   ```
   Adminer est accessible sur `http://<ip-du-vps>:8080` pour gérer la base si besoin.

4. **Installer FXServer et les ressources QBCore**
   ```bash
   ./setup.sh
   ```
   Ce script télécharge le binaire FXServer et clone les ressources QBCore dans
   `server-data/resources/`.

5. **Importer le schéma SQL de QBCore**
   Le fichier SQL se trouve dans `server-data/resources/[qb]/qb-core/qb-core.sql`
   (ou `qbcore.sql` selon la version). L'importer dans la base créée à l'étape 3 :
   ```bash
   docker exec -i gta-rp-db mysql -u qbcore -p qbcore < server-data/resources/[qb]/qb-core/qb-core.sql
   ```

6. **Finaliser server.cfg**
   - Remplacer `PASTE_YOUR_LICENSE_KEY_HERE` par la vraie licence Keymaster.
   - Remplacer `REPLACE_WITH_ADMIN_LICENSE` par l'identifiant `license:` de votre
     propre compte (récupérable dans les logs au premier lancement, ou via
     https://fivem.net -> paramètres du compte).
   - Ajuster `sv_hostname`, `sv_maxclients`, etc.

7. **Démarrer le serveur**
   ```bash
   cd fxserver
   ./run.sh +exec ../server-data/server.cfg
   ```

8. Se connecter via le client FiveM avec l'IP:port de votre VPS
   (`connect <ip>:30120`), ou lister le serveur publiquement dans le
   navigateur de serveurs FiveM (activé par défaut, pas de whitelist).

## File d'attente et écran de règlement

Deux ressources maison sont incluses dans `server-data/resources/[local]/` et
déjà activées dans `server.cfg` :

- **`rp-queue`** — file d'attente FIFO quand le serveur est plein (utile en
  accès libre puisqu'il n'y a pas de whitelist pour limiter l'affluence).
  Éditer `Config.PriorityIdentifiers` dans `server.lua` pour faire passer le
  staff devant (identifiants au format `license:xxxxxxxx`).
- **`rp-welcome`** — écran de règlement affiché à la connexion (le joueur est
  figé tant qu'il n'a pas cliqué sur « J'accepte »), avec logs Discord des
  connexions/déconnexions et acceptations du règlement. Configurer l'URL du
  webhook dans `server.cfg` via `setr rp_welcome_discord_webhook "..."`, et
  adapter le texte des règles dans `resources/[local]/rp-welcome/server.lua`.

## Réputation de gang et conséquences

La ressource `rp-gangs` (déjà activée dans `server.cfg`) fait monter un gang
en "paliers" (Inconnu → Surveillé → Recherché → Dangereux → Ennemi public)
selon son activité criminelle, avec des conséquences concrètes : niveau
recherché du joueur augmenté, multiplicateur d'argent/de risque exposé aux
autres scripts. Voir `server-data/resources/[local]/rp-gangs/README.md`
pour l'intégrer à vos jobs (braquages, ventes de drogue, guerres de
territoire...). Ne pas oublier d'importer `sql/gang_reputation.sql`.

Un roster de 5 organisations est défini dans
`server-data/resources/[local]/rp-gangs/shared/gangs.lua` (nom, territoire,
véhicules, tenue, grades, rivalités) — voir le README de cette resource pour
le détail. Une fois QBCore installé (`./setup.sh`), reporter les grades dans
`qb-core/shared/gangs.lua` à partir de `docs/qb-core-gangs-snippet.lua`.

## Activités criminelles

Onze activités jouables (braquages, vol de véhicule/casse auto, deal de
drogue, course illégale, blanchiment d'argent, labo d'armes, labo de
drogue...) sont déjà activées dans `server.cfg` et branchées sur `rp-gangs`.
Les labos d'armes et de drogue (`rp-weaponlab`, `rp-druglab`) sont en plus
disputables entre gangs via `rp-labwars` (guerre de monopole : le gang qui
contrôle un labo l'exploite moins cher et avec moins de risques). Voir
[`docs/CRIME-JOBS.md`](CRIME-JOBS.md) pour le détail de chacune,
`docs/qb-core-items-snippet.lua` pour l'item requis par le blanchiment, et
importer `rp-labwars/sql/lab_control.sql`.

## Jobs légaux

Six jobs légaux (mécanicien, agent de sécurité, taxi, livreur, éboueur,
bûcheron) sont déjà activés dans `server.cfg`, indépendants du système de
gangs. Voir [`docs/LEGAL-JOBS.md`](LEGAL-JOBS.md) — le mécanicien et l'agent
de sécurité nécessitent d'assigner le métier via
`docs/qb-core-jobs-snippet.lua`, les quatre autres sont ouverts à tous les
joueurs sans configuration supplémentaire.

## Véhicules / armes / maps additionnels

Le dossier `server-data/resources/[addons]/` contient des templates vides
pour ajouter des véhicules moddés, des armes moddées, ou des maps/MLO
custom. Ces contenus nécessitent des fichiers binaires du jeu que je ne
peux pas générer — voir le README de ce dossier pour la structure attendue
et, surtout, les **précautions de sécurité** avant d'installer un pack
téléchargé (risque de backdoor dans les mods "leakés").

## Déploiement en service (redémarrage automatique)

```bash
./deploy/install-service.sh        # installe et démarre le service systemd "gta-rp"
journalctl -u gta-rp -f            # suivre les logs en direct
```

Le service redémarre automatiquement le serveur en cas de crash.

## Pare-feu

```bash
./deploy/firewall.sh   # ouvre uniquement 22 (SSH), 30120 (FiveM), 40120 (txAdmin)
```

## Sauvegardes automatiques de la base de données

```bash
./deploy/backup-db.sh   # sauvegarde manuelle dans ./backups (gzip, rotation 7 jours)
```

Pour l'automatiser, ajouter au crontab (`crontab -e`) :
```
0 4 * * * /chemin/vers/gta-rp/deploy/backup-db.sh >> /var/log/gta-rp-backup.log 2>&1
```

## Accès libre : points d'attention

- Ne **jamais** ajouter de script/`resource` de whitelist ni de vérification
  Discord obligatoire si l'objectif est un accès 100% libre.
- Un serveur ouvert attire plus de comportements toxiques : prévoir une
  équipe de modération, un règlement clair affiché en jeu (`qb-core` permet
  d'afficher un message d'accueil), et éventuellement un anti-cheat tiers
  (ex: FiveGuard, txAdmin ban-list synchronisée).
- Utiliser [txAdmin](https://aka.cfx.re/txadmin) (inclus dans FXServer) pour
  la gestion à distance, les bans, et les sauvegardes automatiques du serveur.
- Respecter les [conditions de Rockstar/Take-Two](https://www.rockstargames.com/policy/mods-policy)
  concernant les mods et l'absence de monétisation abusive.
