# rp-gangs

Système de réputation de gang avec conséquences croissantes, indépendant de
tout job spécifique (compatible avec les jobs custom ou ceux de QBCore).

## Installation

1. Importer `sql/gang_reputation.sql` dans la base de données.
2. `ensure rp-gangs` est déjà présent dans `server.cfg` (après `oxmysql`).

## Utilisation depuis un autre script

Depuis un script serveur (ex : un braquage, une vente de drogue, une fusillade
de territoire), signaler l'action au nom du gang concerné :

```lua
-- Depuis un event serveur, avec `src` = le joueur à l'origine de l'action
TriggerEvent('rp-gangs:server:addReputation', 'eastside_locos', 25)

-- Ou, si l'appel vient d'un event déclenché par le client lui-même :
TriggerServerEvent('rp-gangs:server:addReputation', 'eastside_locos', 25)
```

Pour appliquer une conséquence *directe* sur le joueur (ex: augmentation du
niveau recherché), appeler la fonction exportée avec la source du joueur :

```lua
exports['rp-gangs']:AddReputation('eastside_locos', 25, source)
```

## Lire la réputation / les multiplicateurs

```lua
exports['rp-gangs']:GetGangReputation('eastside_locos', function(points)
    print(points)
end)

exports['rp-gangs']:GetGangMultiplier('eastside_locos', function(incomeMultiplier, policeMultiplier, label)
    -- ex: appliquer incomeMultiplier au gain d'argent d'une vente de drogue
end)

exports['rp-gangs']:GetGangInfo('eastside_locos') -- table complète (territoire, véhicules, tenue, grades...)
exports['rp-gangs']:GetAllGangs() -- toutes les organisations
```

## Roster des gangs (`shared/gangs.lua`)

| Identifiant | Nom | Style | Territoire | Rivaux |
|---|---|---|---|---|
| `eastside_locos` | East Side Locos | Gang de rue | Davis / Strawberry | `reapers_18th` |
| `reapers_18th` | 18th Street Reapers | Gang de rue | Rancho / La Mesa | `eastside_locos` |
| `antonelli_family` | Antonelli Family | Mafia organisée | Rockford Hills / Vinewood Hills | `culebra_cartel` |
| `culebra_cartel` | Culebra Cartel | Cartel | Sandy Shores / Grand Senora Desert | `antonelli_family` |
| `iron_vultures_mc` | Iron Vultures MC | Motards (MC) | Paleto Bay / Grapeseed | — |

Chaque gang définit aussi ses véhicules attitrés, sa tenue, sa spécialité
criminelle (pour savoir quelles actions déclenchent `AddReputation`) et ses
grades internes. Le territoire est affiché en jeu (cercle + marqueur nommé
sur la carte, voir `client/main.lua`) — les coordonnées sont une base de
départ, à ajuster en jeu si besoin.

Pour ajouter un gang : dupliquer une entrée dans `shared/gangs.lua`, puis
reporter ses grades dans `qb-core/shared/gangs.lua` via
`docs/qb-core-gangs-snippet.lua` (voir la racine du repo).

## Personnaliser les paliers et conséquences

- `shared/config.lua` : seuils, multiplicateurs, décroissance horaire.
- `server/main.lua` (fonction `applyConsequences`) : c'est ici qu'on branche
  d'autres systèmes (ex: déclencher un dispatch renforcé côté qb-policejob
  en écoutant l'event `rp-gangs:server:tierChanged`).
