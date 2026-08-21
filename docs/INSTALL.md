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
