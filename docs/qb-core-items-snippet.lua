-- À ajouter dans server-data/resources/[qb]/qb-core/shared/items.lua
-- (dans la table QBShared.Items), pour que rp-laundering fonctionne.

['dirty_cash'] = {
    ['name'] = 'dirty_cash',
    ['label'] = 'Argent sale',
    ['weight'] = 0,
    ['type'] = 'item',
    ['image'] = 'money_dirty.png',
    ['unique'] = false,
    ['useable'] = false,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = "De l'argent qui doit être blanchi avant d'être dépensé (voir /launder)",
},
