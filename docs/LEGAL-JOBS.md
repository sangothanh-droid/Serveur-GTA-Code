# Jobs légaux

Six jobs légaux, tous indépendants les uns des autres. Ils reposent sur
**`rp-job-core`** (helpers partagés : métier du joueur, paiement) plutôt que
sur `rp-crime-core` (qui reste réservé aux activités criminelles).

| Resource | Type | Interaction | Paiement |
|---|---|---|---|
| `rp-mechanic` | Métier assigné (`mechanic`) | `[E]` sur un véhicule au garage LSC Strawberry, en service | $100–250 |
| `rp-security` | Métier assigné (`security`) | Automatique : patrouiller en service sur un site surveillé | $150 / 5 min de présence |
| `rp-taxi` | Ouvert à tous | `/taxi` : direction aléatoire, conduire sur place | $150–400 |
| `rp-delivery` | Ouvert à tous | `[E]` à l'entrepôt du port, livrer la cargaison | $300–600 |
| `rp-garbage` | Ouvert à tous | `[E]` sur les poubelles (8 emplacements, repousse 3 min) | $35 / poubelle |
| `rp-lumberjack` | Ouvert à tous | `[E]` sur les arbres (forêt de Paleto), vendre à la scierie | $60 / unité de bois |

## Installation

1. `rp-mechanic` et `rp-security` nécessitent que le joueur ait le métier
   correspondant dans QBCore : ajouter le contenu de
   `docs/qb-core-jobs-snippet.lua` dans `qb-core/shared/jobs.lua`, puis
   assigner le métier via `/job` (commande admin QBCore) ou votre système
   de recrutement. Le joueur doit être **en service** (`/duty`) pour être
   payé.
2. `rp-taxi`, `rp-delivery`, `rp-garbage`, `rp-lumberjack` ne nécessitent
   aucun métier : accessibles à tout citoyen, comme des petits boulots.
3. Aucune de ces resources ne dépend de `rp-gangs` — elles fonctionnent même
   sur un serveur sans les gangs/activités criminelles.

## Personnalisation

Chaque resource a son `shared/config.lua` : emplacements, montants, délais.
Les coordonnées par défaut sont des points de départ à ajuster selon votre
carte et vos préférences (garage, entrepôt, poubelles, forêt, sites de
patrouille).

## Idées pour aller plus loin (non implémentées)

- Ajouter d'autres métiers assignés (policier, ambulancier, avocat, mairie)
  avec de vraies missions plutôt qu'une simple prime de présence.
- Remplacer le compteur en mémoire de `rp-lumberjack` par un item
  d'inventaire réel.
- Ajouter un système de véhicules de service (dépanneuse, camion,
  fourgon de livraison) au lieu de laisser le joueur utiliser n'importe
  quel véhicule.
