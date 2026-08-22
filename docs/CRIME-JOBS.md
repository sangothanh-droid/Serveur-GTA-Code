# Activités criminelles

Onze activités indépendantes, chacune reliée au système `rp-gangs` (le
joueur doit appartenir à un gang pour en profiter, et chaque succès fait
monter la réputation du gang concerné). Toutes dépendent de
**`rp-crime-core`** (helpers partagés : argent, gang du joueur, alerte
police) et de **QBCore**.

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
| `rp-weaponlab` | `[E]` dans l'un des 5 ateliers (un par arme), fabrique l'arme + munitions | arme du labo | +10 à +30 selon l'arme |
| `rp-druglab` | `[E]` dans l'un des 4 labos (un par drogue), cuisine un lot | $70–160/unité selon la drogue | +10 à +18 par tranche de 5 unités |

### Détail des ateliers d'armes (`rp-weaponlab`)

Un labo = une arme précise, pas de tirage aléatoire. Les noms correspondent
aux armes vanilla GTA V les plus proches (voir la note de sécurité plus bas
si vous voulez le skin visuel exact d'un AK-47/Uzi).

| Labo | Arme produite | Coût (non-propriétaire) | Temps |
|---|---|---|---|
| Atelier Armes de Poing - Davis | `weapon_pistol` | $200 | 15s |
| Atelier Fusils à Pompe - Cypress Flats | `weapon_pumpshotgun` | $350 | 20s |
| Atelier Uzi - Rancho | `weapon_microsmg` | $400 | 22s |
| Atelier AK-47u (compact) - Grand Senora | `weapon_specialcarbine` | $600 | 28s |
| Atelier AK-47 - Paleto Bay | `weapon_assaultrifle` | $800 | 35s |

### Détail des labos de drogue (`rp-druglab`)

La culture de cannabis reste dans `rp-weedfarm` (cycle plantation/récolte
différent d'un labo de cuisson). `rp-druglab` couvre les drogues cuisinées :

| Labo | Produit | Coût (non-propriétaire) | Prix/unité |
|---|---|---|---|
| Labo de Meth - Grand Senora | Méthamphétamine | $400 | $120 |
| Labo de Cocaïne - Storm Drain | Cocaïne | $550 | $160 |
| Labo de Crack - Davis | Crack (cocaïne base) | $250 | $90 |
| Serre à Champignons - Mont Chiliad | Champignons hallucinogènes | $150 | $70 |

## Labos et guerre pour le monopole

`rp-weaponlab` (5 ateliers) et `rp-druglab` (4 labos) sont tous liés à
**`rp-labwars`**, qui gère le contrôle de ces 9 sites comme des territoires
disputés (indépendamment des territoires "maison" de `rp-gangs`) :

- Chaque labo démarre neutre (aucun gang propriétaire).
- Toutes les 30s, si un **seul** gang occupe la zone d'un labo (rayon 15m),
  il gagne des points de contrôle. Si deux gangs ou plus sont présents, rien
  ne se passe (le monopole reste disputé).
- À 100 points, ce gang devient propriétaire du labo (annoncé dans le chat,
  +40 de réputation), et le contrôle est persisté en base
  (`rp-labwars/sql/lab_control.sql`, à importer).
- **Le gang propriétaire paie moitié moins cher** pour fabriquer/cuisiner
  dans "son" labo. Un gang non-propriétaire qui l'utilise quand même a un
  risque d'échec (matériaux perdus / explosion signalée à la police).

C'est ce qui crée l'incitatif à se battre pour le monopole : contrôler un
labo rend son exploitation moins chère et plus sûre, donc plus rentable —
et rien n'empêche un autre gang de venir le reprendre en l'occupant seul
suffisamment longtemps.

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
7. `rp-weaponlab` et `rp-druglab` doivent démarrer **avant** `rp-labwars`
   (déjà fait dans `server.cfg`) : celui-ci lit leurs emplacements de labo
   au démarrage via `exports:GetLabs()`. Importer aussi
   `rp-labwars/sql/lab_control.sql`.
8. `rp-weaponlab` donne de vraies armes/munitions (items QBCore standards :
   `weapon_pistol`, `weapon_pumpshotgun`, `weapon_microsmg`,
   `weapon_specialcarbine`, `weapon_assaultrifle` + munitions associées),
   déjà enregistrées par défaut dans QBCore — aucun item supplémentaire à
   ajouter. Ce ne sont **pas** des skins visuels d'AK-47/Uzi réels : pour ça,
   voir `server-data/resources/[addons]/README.md` et n'utiliser qu'un pack
   de skins d'armes légitime (jamais un pack "leaké").

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
