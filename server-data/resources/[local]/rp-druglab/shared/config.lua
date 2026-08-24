Config = {}

-- La culture de cannabis a son propre cycle de jeu (voir rp-weedfarm) : elle
-- n'est pas incluse ici. Ce labo couvre les drogues "cuisinées" en labo.
--
-- id : identifiant stable utilisé par rp-labwars pour le contrôle de territoire.
Config.Labs = {
    {
        id = 'druglab_meth',
        coords = vector3(2200.0, 3050.0, 47.0),
        label = 'Labo de Meth - Grand Senora',
        cost = 400,
        cookTimeMs = 30000,
        yieldMin = 5,
        yieldMax = 12,
        pricePerUnit = 120,
        repGainPer5Units = 15,
    },
    {
        id = 'druglab_coke',
        coords = vector3(1000.0, -3000.0, -38.9),
        label = 'Labo de Cocaïne - Storm Drain',
        cost = 550,
        cookTimeMs = 35000,
        yieldMin = 4,
        yieldMax = 10,
        pricePerUnit = 160,
        repGainPer5Units = 18,
    },
    {
        id = 'druglab_crack',
        coords = vector3(120.0, -1950.0, 20.0),
        label = 'Labo de Crack - Davis',
        cost = 250,
        cookTimeMs = 20000,
        yieldMin = 6,
        yieldMax = 14,
        pricePerUnit = 90,
        repGainPer5Units = 12,
    },
    {
        id = 'druglab_mushrooms',
        coords = vector3(-1900.0, 2250.0, 130.0),
        label = 'Serre à Champignons - Mont Chiliad',
        cost = 150,
        cookTimeMs = 25000,
        yieldMin = 8,
        yieldMax = 16,
        pricePerUnit = 70,
        repGainPer5Units = 10,
    },
}

Config.InteractDistance = 2.0
Config.MarkerDistance = 15.0

Config.OwnerDiscountPercent = 50      -- remise pour le gang qui contrôle le labo
Config.NonOwnerFailChancePercent = 25 -- chance d'explosion/échec si on n'est pas propriétaire
Config.PoliceCallChancePercent = 30
