# Véhicules : concession et garages

## Découverte importante : `player_vehicles` n'existait pas

`rp-carjack` et `rp-lonewolfcarjack` interrogent tous les deux
`player_vehicles` (`SELECT 1 FROM player_vehicles WHERE plate = ?`) pour
savoir si un véhicule appartient à un joueur avant de le laisser voler/
revendre. Cette table n'a **jamais existé** : elle n'est définie ni dans
`qb-core/qbcore.sql` (qui ne contient que `players`, `bans`,
`player_contacts`), ni ailleurs dans le repo. Ces deux requêtes plantaient
donc silencieusement depuis leur création (erreur SQL "table doesn't
exist" côté oxmysql, avalée sans bloquer le reste du script).

`rp-dealership/sql/player_vehicles.sql` crée cette table (pas une table en
plus : c'est celle que ces deux resources attendaient déjà), avec des
colonnes standard côté écosystème QBCore :

| Colonne | Type | Rôle |
|---|---|---|
| `id` | `int` auto-incrémenté | Clé primaire |
| `citizenid` | `varchar(50)` | Propriétaire (référence `players.citizenid`) |
| `vehicle` | `varchar(50)` | Spawn code du modèle (ex: `asea`) |
| `hash` | `varchar(50)` | Hash du modèle (`GetHashKey`, mis en cache) |
| `plate` | `varchar(15)`, **unique** | Plaque, générée par `rp-dealership` |
| `garage` | `varchar(50)` | `id` du garage où le véhicule est stocké |
| `state` | `tinyint(1)` | `1` = garé, `0` = sorti (voir `rp-garage`) |
| `created_at` | `timestamp` | Date d'achat |

`rp-carjack`/`rp-lonewolfcarjack` ne lisent que la colonne `plate` : leurs
requêtes existantes fonctionnent sans aucune modification une fois la
table créée.

## `rp-dealership` — Concession automobile

Deux points de vente (`Config.Dealerships`) :

| Concession | Type | Emplacement |
|---|---|---|
| Premium Deluxe Motorsport | Véhicules (`automobile`) | Rockford Hills |
| Southside Bike Shop | Motos (`bike`) | Vespucci |

`Config.Catalog` liste 25 véhicules (22 voitures + 3 motos, spawn codes
vanilla GTA V repris de `qb-core/shared/vehicles.lua`), de $2 500
(Declasse Asea) à $155 000 (Grotti Carbonizzare), répartis en citadines,
berlines, SUV et sportives.

À proximité d'un marker, `[E]` ouvre un menu `qb-menu` filtré par
`vehicleType` de la concession. Choisir un véhicule ouvre un sous-menu :

- **Essayer** : fait apparaître le véhicule (côté client uniquement, pas
  de vérification serveur ni de coût) pour une durée de
  `Config.TestDriveTimeMs` (60s). L'essai est annulé automatiquement si le
  joueur s'éloigne de plus de `Config.TestDriveWanderDistance` (60m) du
  véhicule, ou à l'expiration du délai.
- **Acheter** : le serveur revérifie la proximité de la concession et le
  solde bancaire (`QBCore`), débite le prix, génère une plaque unique
  (préfixe `MRP` + 5 caractères aléatoires, unicité vérifiée par la même
  requête que `rp-carjack`), puis insère la ligne dans `player_vehicles`
  avec `state = 1` (garé) et `garage = Config.Dealerships[i].deliveryGarage`.
  **Aucun véhicule ne spawn à l'achat** : il faut aller le récupérer au
  garage assigné (voir `rp-garage` ci-dessous).

## `rp-garage` — Garages

*(Phase 2 — à venir dans un prochain commit.)*

## Installation

1. Importer `rp-dealership/sql/player_vehicles.sql` dans la base — c'est
   la seule table nécessaire pour tout ce système (concession + garages +
   revente), rien d'autre à créer.
2. `ensure rp-dealership` nécessite `oxmysql` et `qb-core` (déjà garantis
   par leur position dans `server.cfg.example`).
3. Aucune dépendance vers `rp-gangs`/`rp-crime-core` pour la concession
   classique — uniquement pour le futur marché noir (Phase 3 bonus).

## Personnalisation

`shared/config.lua` : emplacements des concessions, catalogue (modèle,
libellé, prix, type), durée/distance d'essai, préfixe de plaque. Les
coordonnées par défaut sont des points de départ à ajuster selon votre
carte.
