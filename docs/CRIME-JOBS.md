# Activités criminelles

Neuf activités indépendantes, chacune reliée au système `rp-gangs` (le joueur
doit appartenir à un gang pour en profiter, et chaque succès fait monter la
réputation du gang concerné). Toutes dépendent de **`rp-crime-core`**
(helpers partagés : argent, gang du joueur, alerte police) et de **QBCore**.

| Resource | Commande / interaction | Récompense | Réputation |
|---|---|---|---|
| `rp-shoprobbery` | Approcher un magasin (5 emplacements), `[E]` pour braquer | $500–1500 | +15 |
| `rp-carjack` | Amener un véhicule à la casse de Cypress Flats, `[E]` | $800–3500 | +20 |
| `rp-drugdealing` | `/dealdrugs` près d'un PNJ | $80–250 | +5 |
| `rp-illegalrace` | `/race start [numéro de circuit]`, les autres font `/race join` | $500–1000 au vainqueur | +10 |
| `rp-laundering` | `/launder <montant>` à la blanchisserie Antonelli | montant - commission | +5 par tranche de $1000 |
| `rp-heist` | Braquage de banque (3 Fleeca), `[E]` : alarme puis coffre | $5000–15000 | +60 |
| `rp-armstrafficking` | `[E]` au point de rendez-vous désert, risque d'embuscade | $1000–4000 | +25 |
| `rp-turfwar` | Automatique : occuper seul le territoire d'un autre gang | — | +50 au gang qui capture |
| `rp-weedfarm` | `[E]` sur les plants (désert), puis `[E]` au labo pour vendre | $350/unité | +10 par tranche de 5 unités |

## Installation

1. `ensure rp-crime-core` doit être chargé **avant** les autres resources
   (déjà fait dans `server.cfg`).
2. `rp-laundering` nécessite l'item `dirty_cash` : ajouter le contenu de
   `docs/qb-core-items-snippet.lua` dans
   `qb-core/shared/items.lua`. Par défaut, rien ne donne cet item — à vous
   de décider quelle activité en octroie (ex: modifier `rp-shoprobbery` pour
   donner `dirty_cash` au lieu de cash directement, via
   `Player.Functions.AddItem('dirty_cash', reward)`).
3. `rp-carjack` vérifie que le véhicule n'appartient pas au joueur via la
   table `player_vehicles` de QBCore (déjà créée par son propre schéma SQL).
4. `rp-heist` bloque le braquage si aucun policier n'est en service
   (`Config.MinPoliceOnline`), pour éviter les braquages sans risque.
5. `rp-turfwar` persiste le propriétaire de chaque territoire en base
   (`sql/gang_territories.sql`, à importer) et tourne en tâche de fond :
   toutes les 30s, si un seul gang (différent du propriétaire) occupe la
   zone d'un autre gang, il gagne des points ; à 100 points, le contrôle
   bascule et son gang gagne de la réputation. Aucune interaction manuelle
   requise.
6. `rp-weedfarm` ne nécessite aucun item d'inventaire : la récolte est
   comptabilisée en mémoire par joueur (remise à zéro à la déconnexion) puis
   convertie en argent au labo de conditionnement.

## Personnalisation

Chaque resource a son `shared/config.lua` : emplacements, montants,
probabilités, cooldowns. Les emplacements par défaut (magasins, casse auto,
circuit, façade, banques, point de deal, plants) sont des coordonnées de
départ à ajuster en jeu selon vos préférences.

## Idées pour aller plus loin (non implémentées)

- Faire varier les emplacements/montants selon le palier de réputation du
  gang (`exports['rp-gangs']:GetGangMultiplier`).
- Ajouter des zones de vente de drogue fixes plutôt que des PNJ aléatoires.
- Relier `rp-illegalrace` à des véhicules spécifiques par gang
  (`shared/gangs.lua` définit déjà des véhicules attitrés).
- Faire évoluer les blips de territoire (`rp-gangs`) pour refléter le
  propriétaire actuel exposé par `exports['rp-turfwar']:GetTerritoryOwner`.
- Remplacer le compteur en mémoire de `rp-weedfarm` par un vrai item
  d'inventaire (comme `dirty_cash` pour le blanchiment).
