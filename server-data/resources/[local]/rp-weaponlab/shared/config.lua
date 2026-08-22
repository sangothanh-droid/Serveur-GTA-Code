Config = {}

-- Un labo = une arme précise (pas de tirage aléatoire). Les noms "AK-47",
-- "AK-47u", "Uzi" correspondent aux armes vanilla GTA V les plus proches
-- (aucun skin visuel réel d'AK/Uzi n'est inclus : voir
-- server-data/resources/[addons]/README.md pour ajouter un pack de skins
-- d'armes légitime si vous en voulez l'apparence exacte).
--
-- id : identifiant stable utilisé par rp-labwars pour le contrôle de territoire.
Config.Labs = {
    {
        id = 'weaponlab_pistol',
        coords = vector3(95.0, -1900.0, 20.0),
        label = 'Atelier Armes de Poing - Davis',
        item = 'weapon_pistol',
        ammo = 'pistol_ammo',
        ammoAmount = 40,
        cost = 200,
        craftTimeMs = 15000,
        repGain = 10,
    },
    {
        id = 'weaponlab_shotgun',
        coords = vector3(920.0, -2190.0, 30.0),
        label = 'Atelier Fusils à Pompe - Cypress Flats',
        item = 'weapon_pumpshotgun',
        ammo = 'shotgun_ammo',
        ammoAmount = 16,
        cost = 350,
        craftTimeMs = 20000,
        repGain = 15,
    },
    {
        id = 'weaponlab_uzi',
        coords = vector3(300.0, -2050.0, 20.0),
        label = 'Atelier Uzi - Rancho',
        item = 'weapon_microsmg', -- équivalent vanilla le plus proche d'un Uzi
        ammo = 'smg_ammo',
        ammoAmount = 50,
        cost = 400,
        craftTimeMs = 22000,
        repGain = 18,
    },
    {
        id = 'weaponlab_ak47u',
        coords = vector3(1980.0, 3050.0, 47.2),
        label = 'Atelier AK-47u (compact) - Grand Senora',
        item = 'weapon_specialcarbine', -- équivalent vanilla d'une carabine compacte type AK court
        ammo = 'rifle_ammo',
        ammoAmount = 45,
        cost = 600,
        craftTimeMs = 28000,
        repGain = 25,
    },
    {
        id = 'weaponlab_ak47',
        coords = vector3(-90.0, 6320.0, 31.5),
        label = 'Atelier AK-47 - Paleto Bay',
        item = 'weapon_assaultrifle', -- équivalent vanilla le plus proche d'un AK-47
        ammo = 'rifle_ammo',
        ammoAmount = 60,
        cost = 800,
        craftTimeMs = 35000,
        repGain = 30,
    },
}

Config.InteractDistance = 2.0
Config.MarkerDistance = 15.0

Config.OwnerDiscountPercent = 50      -- remise pour le gang qui contrôle le labo
Config.NonOwnerFailChancePercent = 25 -- chance d'échec (matériaux perdus) si on n'est pas propriétaire
Config.PoliceCallChancePercent = 25
