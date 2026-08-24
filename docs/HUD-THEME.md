# Thème visuel des blips (carte)

Code couleur cohérent pour tous les blips créés par nos resources
(`server-data/resources/[local]/rp-*`). Les valeurs numériques sont celles
attendues par `SetBlipColour` (palette native GTA V/FiveM, ~86 teintes).

| Catégorie | Couleur | ID `SetBlipColour` |
|---|---|---|
| Illégal / territoires de gangs | Rouge | `1` |
| Jobs légaux / services publics (générique) | Bleu | `3` |
| Police (spécifique) | Bleu foncé | `29` |
| Ambulance (spécifique) | Blanc | `0` |
| Pompier (spécifique) | Orange | `17` |
| Loisirs (casino, laser game, arcade, carmeet) | Jaune/or | `46` |
| Points de vente / gains (revente, marchés) | Vert | `2` |

## Où c'est appliqué

| Resource | Blip(s) | Couleur |
|---|---|---|
| `rp-crime-core` | Alerte police (temporaire, sur le lieu d'une activité illégale) | Rouge (`1`) — déjà correct, inchangé |
| `rp-bountyhunter` | Cible active | Rouge (`1`) — déjà correct, inchangé |
| `rp-gangwar-events` | Point chaud (hotzone) | Rouge (`1`) — déjà correct, inchangé |
| `rp-security` | Sites de patrouille (zone + marqueur) | Bleu (`3`) — déjà correct, inchangé |
| `rp-realestate` | Biens immobiliers (zone + marqueur) | Bleu (`3`) — changé (était jaune `5`) |
| `rp-taxi` | Destination de la course | Bleu (`3`) — changé (était jaune `5`) |
| `rp-delivery` | Point de livraison | Bleu (`3`) — changé (était jaune `5`) |
| `rp-police` | Commissariat (nouveau blip, sprite `60`) | Bleu foncé (`29`) |
| `rp-ambulance` | Hôpital (nouveau blip, sprite `61`, déjà une croix rouge/blanc) | Blanc (`0`) |
| `rp-firefighter` | Incendie actif (nouveau blip, sprite `436`, tant qu'il brûle) | Orange (`17`) |
| `rp-nightclub` | Boîte de nuit (zone + marqueur) | Or (`46`) — changé (était `27`) |
| `rp-carmeet` | Point de rassemblement | Or (`46`) — changé (était jaune `5`) |
| `rp-lasergame` | Arène (zone + marqueur) | Or (`46`) — changé (était jaune `5`) |
| `rp-gangs` | Territoires (zone + marqueur), une couleur par gang | **Exception volontaire**, voir ci-dessous |

Aucun blip actuel n'entre dans la catégorie "vert" (points de
vente/gains) : c'est une réservation pour une future resource (ex: un
marché légal, un point de revente fixe) plutôt qu'un changement rétroactif.

`rp-weaponlab`, `rp-druglab`, `rp-labwars` et `rp-turfwar` n'ont **aucun
blip** (uniquement des marqueurs au sol `DrawMarker`, visibles seulement à
proximité) : rien à harmoniser pour eux dans ce document, c'est un choix
de design existant (ne pas révéler l'emplacement des labos/territoires sur
toute la carte).

## Exception : `rp-gangs`

Les territoires de gangs gardent une couleur **par gang**
(`gang.blipColor` dans `rp-gangs/shared/gangs.lua`, ex. vert pour les East
Side Locos, rouge pour les 18th Street Reapers, gris foncé pour les
Antonelli, doré pour le Culebra Cartel, bleu-gris pour les Iron Vultures)
plutôt qu'un rouge uniforme. C'est intentionnel : uniformiser en rouge
rendrait les 5 territoires indiscernables entre eux sur la carte, alors que
la couleur par gang permet de voir au premier coup d'œil à qui appartient
quel territoire. La règle "rouge = illégal/gangs" reste respectée au sens
large (ce sont bien des activités illégales), avec cette nuance pour
préserver la lisibilité.

## Sprites

Les sprites (icônes) des blips déjà en place n'ont pas été changés — seule
la couleur a été harmonisée, comme demandé. Les 3 nouveaux blips
(commissariat, hôpital, incendie actif) utilisent les icônes vanilla les
plus proches disponibles dans GTA V :

- `60` = `radar_police_station` (commissariat)
- `61` = `radar_hospital` (croix d'hôpital)
- `436` = `HotProperty` (flamme, réutilisée pour le pompier comme pour le
  point chaud de `rp-gangwar-events` — il n'existe pas d'icône "caserne de
  pompiers" dédiée dans la palette vanilla de GTA V)

## Pour toute nouvelle resource

Réutiliser une des 7 couleurs ci-dessus selon la catégorie de la resource.
Si aucune ne convient clairement, ouvrir la discussion plutôt que
d'inventer une 8e couleur ad hoc — l'intérêt du thème est justement de
rester à un nombre de couleurs limité et mémorisable pour les joueurs.
