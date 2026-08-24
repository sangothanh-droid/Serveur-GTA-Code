# Petites frappes solo (hors gangs officiels)

Ce volet est un système **parallèle** aux 5 gangs officiels de `rp-gangs`
et à leurs activités criminelles (`docs/CRIME-JOBS.md`). Il est destiné aux
joueurs qui ne font partie d'**aucun** de ces gangs — les "petites frappes"
solo ou en groupe non officiel — avec sa propre progression, séparée de la
réputation de gang.

**Réservé aux joueurs sans gang.** Chaque resource ci-dessous vérifie via
`exports['rp-crime-core']:GetPlayerGang(source)` que le joueur n'a pas de
gang avant d'autoriser l'activité. Un membre d'un des 5 gangs officiels ne
peut pas cumuler ce système avec la réputation de gang : il doit utiliser
les activités liées aux gangs (`rp-shoprobbery`, `rp-carjack`,
`rp-bountyhunter`, etc.), pas celles-ci.

## rp-streetrep — réputation de rue

Remplace `rp-crime-core` pour ce volet : un score de réputation **par
joueur** (et non par gang), stocké en base dans la table `street_reputation`
(`rp-streetrep/sql/street_reputation.sql`, à importer).

Exports (asynchrones, comme `rp-gangs:GetGangReputation`) :

- `GetStreetRep(source, cb)` — `cb(points)`.
- `AddStreetRep(source, amount)` — ajoute (ou retire, si négatif) des
  points ; sauvegarde immédiate en base.
- `HasRiskReduction(source, cb)` — `cb(true/false)`, vrai à partir de
  `Config.RiskReductionThreshold` (100 par défaut). Pas de palier
  obligatoire au-delà : c'est un score simple, ce seuil n'est qu'un exemple
  d'avantage optionnel qu'une activité peut interroger (aucune des 4
  activités ci-dessous ne l'utilise pour l'instant, voir "Idées").
- `/streetrep` (commande joueur) affiche son propre score dans le chat.

## rp-pettycrime — quatre activités rapides

Une seule resource, quatre interactions indépendantes. Chaque succès donne
un peu d'argent (payé directement via QBCore, pas via `rp-crime-core`) et
un peu de `rp-streetrep`.

| Activité | Interaction | Récompense | Réputation de rue |
|---|---|---|---|
| Vol à la tire | `/pickpocket` près d'un PNJ | $20–80 | +3 |
| Vol d'autoradio | `[E]` sur l'un des 4 véhicules garés | $40–150 | +4 |
| Vol de boîte aux lettres | `[E]` sur l'une des 3 boîtes | $15–60 | +2 |
| Tag de graffiti | `[E]` sur l'un des 3 murs désignés | $10–30 | +6 |

Le tag de graffiti n'a **aucun lien** avec les territoires de `rp-gangs` :
c'est un coup de projecteur sur la réputation de rue individuelle, pas une
prise de territoire.

Chaque activité a son propre cooldown (par joueur pour le vol à la tire,
par emplacement pour les 3 autres) et sa propre chance d'alerte police
(`exports['rp-crime-core']:AlertPolice`, réutilisé tel quel).

## rp-soloburglary — cambriolages en rotation

`Config.HousePool` liste 10 maisons candidates ; seules `Config.ActiveCount`
(3 par défaut) sont "vides" et cambriolables à un instant donné. Toutes les
`Config.RotationIntervalMs` (15 min par défaut), un nouveau tirage a lieu
parmi le pool complet — cela évite qu'un joueur mémorise et farme les 3
mêmes maisons en continu. Chaque maison a en plus son propre cooldown
(`Config.CooldownMs`, 10 min) indépendant de la rotation, pour ne pas
pouvoir la refaire immédiatement si elle retombe active.

`[E]` sur une maison active déclenche une fouille chronométrée
(`Config.SearchTimeMs`), puis un butin variable (`Config.LootMin`–
`Config.LootMax`) et de la réputation de rue.

## rp-lonewolfcarjack — vol de véhicule solo

Distinct de `rp-carjack` (qui reste lié aux gangs, avec un site de revente
fixe à Cypress Flats). Ici :

- Vol **n'importe où en ville** : `[E]` en étant conducteur de n'importe
  quel véhicule non possédé (vérifié via la table `player_vehicles`,
  comme `rp-carjack`), pas de trajet vers une casse.
- Revente immédiate, gain plus faible (`Config.RewardMin`–
  `Config.RewardMax` : $300–1200 contre $800–3500 pour `rp-carjack`).
- Risque plus élevé : l'alerte police est envoyée **dès le début du vol**,
  à l'endroit où il a lieu — contrairement à `rp-carjack`, qui n'alerte
  qu'à la revente, sur un site fixe et déjà surveillé par la police.

## Installation

1. Importer `rp-streetrep/sql/street_reputation.sql` dans la base.
2. `ensure rp-streetrep` doit être chargé **avant** `rp-pettycrime`,
   `rp-soloburglary` et `rp-lonewolfcarjack` (déjà fait dans `server.cfg`).
3. Aucun nouvel item d'inventaire QBCore n'est nécessaire pour ce volet.
4. `rp-soloburglary` et `rp-lonewolfcarjack` synchronisent leur état côté
   client via `onClientResourceStart` (maisons actives) et une vérification
   serveur sur `player_vehicles` (véhicule non possédé) respectivement —
   aucune configuration supplémentaire requise.

## Personnalisation

Chaque resource a son `shared/config.lua` : emplacements, montants,
probabilités, cooldowns. Les emplacements par défaut (véhicules garés,
boîtes aux lettres, murs, pool de maisons) sont des coordonnées de départ à
ajuster selon votre carte.

## Idées pour aller plus loin (non implémentées)

- Utiliser `rp-streetrep:HasRiskReduction` dans `rp-pettycrime`/
  `rp-soloburglary`/`rp-lonewolfcarjack` pour réduire `PoliceCallChancePercent`
  une fois le seuil de réputation de rue atteint.
- Ajouter un classement (leaderboard) des meilleures réputations de rue,
  affiché via une commande admin ou un tableau web (Adminer suffit pour le
  moment en lecture directe sur `street_reputation`).
- Remplacer le vol d'autoradio par un vrai item d'inventaire revendable
  plutôt qu'un gain en argent direct.
