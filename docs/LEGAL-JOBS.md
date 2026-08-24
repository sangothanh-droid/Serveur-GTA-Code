# Jobs légaux

Dix-sept jobs légaux, tous indépendants les uns des autres. Ils reposent sur
**`rp-job-core`** (helpers partagés : métier du joueur, paiement) plutôt que
sur `rp-crime-core` (qui reste réservé aux activités criminelles).

| Resource | Type | Interaction | Paiement |
|---|---|---|---|
| `rp-mechanic` | Métier assigné (`mechanic`) | `[E]` sur un véhicule au garage LSC Strawberry, en service | $100–250 |
| `rp-security` | Métier assigné (`security`) | Automatique : patrouiller en service sur un site surveillé | $150 / 5 min de présence |
| `rp-realestate` | Métier assigné (`realestate`) | Automatique : assurer des visites en service sur site | $180 / 5 min de présence |
| `rp-taxi` | Ouvert à tous | `/taxi` : direction aléatoire, conduire sur place | $150–400 |
| `rp-delivery` | Ouvert à tous | `[E]` à l'entrepôt du port, livrer la cargaison | $300–600 |
| `rp-garbage` | Ouvert à tous | `[E]` sur les poubelles (8 emplacements, repousse 3 min) | $35 / poubelle |
| `rp-lumberjack` | Ouvert à tous | `[E]` sur les arbres (forêt de Paleto), vendre à la scierie | $60 / unité de bois |
| `rp-fisherman` | Ouvert à tous | `[E]` sur 4 coins de pêche, vendre au marché de Del Perro | $45 / poisson |
| `rp-postal` | Ouvert à tous | `[E]` au bureau de poste : tournée de 5 boîtes aux lettres | $80 / arrêt (400 la tournée) |
| `rp-busker` | Ouvert à tous, sans déplacement | `/perform` (animation musicien, 10s) | $20–80 (x2 si généreux) |
| `rp-carwash` | Ouvert à tous | `[E]` sur un véhicule sale, à l'une des 2 stations-service | $40–90 |
| `rp-police` | Métier assigné (`police`, déjà natif QBCore) | `/cuff`, `/uncuff`, `/search`, `/ticket <montant> <raison>`, `/impound`, véhicule de service au commissariat | Amendes vers la banque, $50/fourrière |
| `rp-ambulance` | Métier assigné (`ambulance`, déjà natif QBCore) | `/revive` sur un joueur à terre, `/heal` (payant), véhicule de service à l'hôpital | $50/soin |
| `rp-firefighter` | Métier assigné (`fire`) | Incendie aléatoire (4 emplacements, ~8 min), `[E]` avec extincteur | $200–450 (+$150 si victime secourue) |
| `rp-restaurant` | Métier assigné (`burgershot`) | `[E]` en cuisine pour préparer, `[E]` au comptoir pour vendre | $45/plat |
| `rp-barber` | Ouvert à tous | `[E]` (visuel) puis `/barber <couleur> [couleur barbe]` (2 salons) | Coûte $75 |
| `rp-nightclub` | Métier assigné (`dj`) | `/ambiance` dans la boîte de nuit (rayon 40m) | Bonus passif $20/min aux clients pendant 10 min |

## Installation

1. `rp-mechanic`, `rp-security` et `rp-realestate` nécessitent que le joueur
   ait le métier correspondant dans QBCore : ajouter le contenu de
   `docs/qb-core-jobs-snippet.lua` dans `qb-core/shared/jobs.lua`, puis
   assigner le métier via `/job` (commande admin QBCore) ou votre système
   de recrutement. Le joueur doit être **en service** (`/duty`) pour être
   payé.
2. `rp-taxi`, `rp-delivery`, `rp-garbage`, `rp-lumberjack`, `rp-fisherman`,
   `rp-postal`, `rp-busker` et `rp-carwash` ne nécessitent aucun métier :
   accessibles à tout citoyen, comme des petits boulots.
3. Aucune de ces resources ne dépend de `rp-gangs` — elles fonctionnent même
   sur un serveur sans les gangs/activités criminelles.
4. `rp-carwash` vérifie la saleté du véhicule (`GetVehicleDirtLevel`) : il
   faut qu'il soit visiblement sale (`Config.MinDirtLevel`) pour pouvoir le
   laver, sinon le jeu le remet à 0 immédiatement sans intérêt.
5. `rp-police` et `rp-ambulance` utilisent les jobs `police`/`ambulance`
   **déjà définis par défaut** dans `qb-core/shared/jobs.lua` : rien à
   ajouter. `rp-firefighter`, `rp-restaurant` et `rp-nightclub` nécessitent
   en revanche d'ajouter leurs jobs (`fire`, `burgershot`, `dj`) via
   `docs/qb-core-jobs-snippet.lua`.
6. `rp-police` se branche sur `rp-crime-core:AlertPolice` (voir
   `docs/CRIME-JOBS.md`) : les policiers **en service** reçoivent
   désormais un blip temporaire *et* un message dans le chat pour chaque
   alerte (braquage, ATM, etc.), pas seulement le blip comme avant. Cette
   modification est rétrocompatible : la signature `AlertPolice(coords,
   message)` n'a pas changé, les 9 resources qui l'appellent déjà
   continuent de fonctionner sans modification.
7. `rp-ambulance` remplace la mort/respawn par défaut de FiveM par un état
   "à terre" (désactive `spawnmanager`'s auto-respawn au démarrage de la
   resource) : un joueur dont la vie tombe à 0 tombe au sol, contrôles
   très limités, jusqu'à `/revive` par un ambulancier en service. Pensez à
   ne pas `ensure` une autre resource qui gère aussi la mort/respawn
   (ex: un vrai qb-ambulancejob) en même temps que celle-ci, pour éviter
   un conflit sur le même événement.
8. `rp-barber` ne persiste pas l'apparence en base : un changement de
   couleur de cheveux/barbe est immédiat mais peut être écrasé par
   `qb-clothing` au prochain relog si vous utilisez son propre système de
   sauvegarde d'apparence. À adapter selon vos besoins.

## Divertissement / social

Deux resources ouvertes à tous, sans lien avec un métier ou un gang :

| Resource | Interaction | Notes |
|---|---|---|
| `rp-casino` | `[E]` (visuel) puis `/casino <montant>` près de la table de jeu (Diamond Casino) | Mise entre `Config.MinBet` et `Config.MaxBet` ; 45% de chance de gagner x1.8 (avantage maison volontaire pour ne pas casser l'économie) |
| `rp-carmeet` | `/startmeet` | Prévient tous les joueurs dans un rayon de 300m (blip + marqueur au sol pendant 15 min) ; cooldown de 5 min par organisateur, aucun argent en jeu |

`rp-casino` retire/ajoute l'argent directement via QBCore (`Player.Functions.RemoveMoney`/`AddMoney`)
plutôt que via `rp-job-core`/`rp-crime-core`, puisqu'il n'est lié ni à un
métier ni à un gang.

## Personnalisation

Chaque resource a son `shared/config.lua` : emplacements, montants, délais.
Les coordonnées par défaut sont des points de départ à ajuster selon votre
carte et vos préférences (garage, entrepôt, poubelles, forêt, coins de
pêche, tournée postale, sites de patrouille/visite, stations-service,
table de jeu, commissariat, hôpital, incendies, cuisine, salons de
coiffure, boîte de nuit).

## Idées pour aller plus loin (non implémentées)

- Ajouter d'autres métiers assignés (avocat, mairie) avec de vraies
  missions plutôt qu'une simple prime de présence.
- `rp-police`/`rp-ambulance` : remplacer les commandes chat (`/cuff`,
  `/ticket`, `/heal`...) par un menu contextuel si vous ajoutez une
  resource de menu dédiée.
- Persister l'apparence de `rp-barber` en base (comme `qb-clothing` le
  fait pour les tenues).
- Ajouter un vrai ped hostile ou un vrai item "extincteur" à
  `rp-firefighter` plutôt qu'une action de proximité générique.
- Remplacer le compteur en mémoire de `rp-lumberjack`/`rp-fisherman`/
  `rp-restaurant` par un item d'inventaire réel.
- Ajouter un système de véhicules de service (dépanneuse, camion,
  fourgon de livraison, camionnette postale) au lieu de laisser le joueur
  utiliser n'importe quel véhicule.
- Varier le contenu de la tournée `rp-postal` (arrêts aléatoires parmi un
  plus grand pool) plutôt qu'un trajet fixe.
