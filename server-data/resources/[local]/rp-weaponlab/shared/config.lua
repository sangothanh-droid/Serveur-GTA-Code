Config = {}

-- id : identifiant stable utilisé par rp-labwars pour le contrôle de territoire.
Config.Labs = {
    { id = 'weaponlab_sandy',  coords = vector3(1980.0, 3050.0, 47.2), label = 'Atelier Clandestin - Grand Senora' },
    { id = 'weaponlab_paleto', coords = vector3(-90.0, 6320.0, 31.5),  label = 'Atelier Clandestin - Paleto Bay' },
}

Config.InteractDistance = 2.0
Config.MarkerDistance = 15.0
Config.CraftTimeMs = 25000

Config.MaterialCost = 300          -- coût des matériaux pour un non-propriétaire
Config.OwnerDiscountPercent = 50   -- remise pour le gang qui contrôle le labo
Config.NonOwnerFailChancePercent = 25 -- chance d'échec (matériaux perdus) si on n'est pas propriétaire

-- Table de loot pondérée (weight = poids relatif, pas un pourcentage direct).
Config.LootTable = {
    { item = 'weapon_pistol',       ammo = 'pistol_ammo',  ammoAmount = 30, weight = 50 },
    { item = 'weapon_smg',          ammo = 'smg_ammo',     ammoAmount = 40, weight = 30 },
    { item = 'weapon_pumpshotgun',  ammo = 'shotgun_ammo', ammoAmount = 16, weight = 15 },
    { item = 'weapon_assaultrifle', ammo = 'rifle_ammo',   ammoAmount = 60, weight = 5 },
}

Config.RepGain = 20
Config.PoliceCallChancePercent = 25
