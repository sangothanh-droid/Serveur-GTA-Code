-- Roster des gangs/organisations criminelles du serveur.
-- Source de vérité pour rp-gangs (réputation, territoires, blips) et pour
-- les grades QBCore (voir docs/qb-core-gangs-snippet.lua pour les reporter
-- dans qb-core/shared/gangs.lua une fois le framework installé).
--
-- blipColor : index de couleur de blip FiveM (voir docs.fivem.net/natives/?_0x03D7FB09E75D6B7E)
-- color     : couleur hexa utilisée par vos propres UI (HUD, menus...)

Gangs = {
    eastside_locos = {
        label = 'East Side Locos',
        style = 'Gang de rue',
        color = '#3CB043',
        blipColor = 2, -- vert
        territory = { label = 'Davis / Strawberry', coords = vector3(115.0, -1650.0, 30.0), radius = 350.0 },
        specialty = "Deal de rue, home invasions, chop shop",
        vehicles = { 'buccaneer', 'voodoo', 'blade' },
        outfit = 'Streetwear vert/noir (via qb-clothing ou tenue vanilla)',
        rivals = { 'reapers_18th' },
        grades = {
            [0] = 'Recrue',
            [1] = 'Soldat',
            [2] = 'Lieutenant',
            [3] = 'Boss',
        },
    },

    reapers_18th = {
        label = '18th Street Reapers',
        style = 'Gang de rue',
        color = '#C21807',
        blipColor = 1, -- rouge
        territory = { label = 'Rancho / La Mesa', coords = vector3(410.0, -1950.0, 30.0), radius = 400.0 },
        specialty = "Extorsion de commerces, trafic d'armes local",
        vehicles = { 'tornado', 'buccaneer2', 'faction' },
        outfit = 'Streetwear rouge/noir',
        rivals = { 'eastside_locos' },
        grades = {
            [0] = 'Recrue',
            [1] = 'Soldat',
            [2] = 'Lieutenant',
            [3] = 'Boss',
        },
    },

    antonelli_family = {
        label = 'Antonelli Family',
        style = 'Mafia organisée',
        color = '#1E1E1E',
        blipColor = 39, -- gris foncé
        territory = { label = 'Rockford Hills / Vinewood Hills', coords = vector3(-560.0, -50.0, 40.0), radius = 450.0 },
        specialty = 'Blanchiment via entreprises façade, usure, corruption',
        vehicles = { 'stretch', 'schafter5', 'cognoscenti2' },
        outfit = 'Costumes sombres (via qb-clothing)',
        rivals = { 'culebra_cartel' },
        grades = {
            [0] = 'Associé',
            [1] = 'Soldat',
            [2] = 'Capo',
            [3] = 'Consigliere',
            [4] = 'Don',
        },
    },

    culebra_cartel = {
        label = 'Culebra Cartel',
        style = 'Cartel',
        color = '#D4A017',
        blipColor = 46, -- doré/orange
        territory = { label = 'Sandy Shores / Grand Senora Desert', coords = vector3(1850.0, 3500.0, 33.0), radius = 800.0 },
        specialty = 'Production/trafic de drogue à grande échelle, contrebande par piste clandestine',
        vehicles = { 'sandking2', 'rebel2', 'cavalcade2' },
        outfit = 'Tenue tactique désert',
        rivals = { 'antonelli_family' },
        grades = {
            [0] = 'Mule',
            [1] = 'Sicario',
            [2] = 'Lieutenant',
            [3] = 'Jefe',
        },
    },

    iron_vultures_mc = {
        label = 'Iron Vultures MC',
        style = 'Motards (MC)',
        color = '#5C5C5C',
        blipColor = 3, -- bleu-gris
        territory = { label = 'Paleto Bay / Grapeseed', coords = vector3(-350.0, 6100.0, 31.0), radius = 700.0 },
        specialty = "Trafic d'armes, racket de protection, courses illégales",
        vehicles = { 'daemon', 'bagger', 'zombiea' },
        outfit = 'Cuir/blousons du club (via qb-clothing)',
        rivals = {},
        grades = {
            [0] = 'Prospect',
            [1] = 'Membre',
            [2] = "Sergent d'armes",
            [3] = 'Président',
        },
    },
}
