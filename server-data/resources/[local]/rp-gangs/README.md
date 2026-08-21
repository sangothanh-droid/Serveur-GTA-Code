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
TriggerEvent('rp-gangs:server:addReputation', 'ballas', 25)

-- Ou, si l'appel vient d'un event déclenché par le client lui-même :
TriggerServerEvent('rp-gangs:server:addReputation', 'ballas', 25)
```

Pour appliquer une conséquence *directe* sur le joueur (ex: augmentation du
niveau recherché), appeler la fonction exportée avec la source du joueur :

```lua
exports['rp-gangs']:AddReputation('ballas', 25, source)
```

## Lire la réputation / les multiplicateurs

```lua
exports['rp-gangs']:GetGangReputation('ballas', function(points)
    print(points)
end)

exports['rp-gangs']:GetGangMultiplier('ballas', function(incomeMultiplier, policeMultiplier, label)
    -- ex: appliquer incomeMultiplier au gain d'argent d'une vente de drogue
end)
```

## Personnaliser les paliers et conséquences

- `shared/config.lua` : seuils, multiplicateurs, décroissance horaire.
- `server/main.lua` (fonction `applyConsequences`) : c'est ici qu'on branche
  d'autres systèmes (ex: déclencher un dispatch renforcé côté qb-policejob
  en écoutant l'event `rp-gangs:server:tierChanged`).
