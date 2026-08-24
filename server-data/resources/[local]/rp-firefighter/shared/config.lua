Config = {}

Config.JobName = 'fire' -- voir docs/qb-core-jobs-snippet.lua

Config.FireLocations = {
    { coords = vector3(-330.0, -1400.0, 30.0), label = 'Entrepôt - La Mesa' },
    { coords = vector3(120.0, 100.0, 80.0),    label = 'Immeuble - Vinewood' },
    { coords = vector3(1200.0, -450.0, 65.0),  label = 'Station essence - East Los Santos' },
    { coords = vector3(-1100.0, 4900.0, 220.0), label = 'Forêt - Paleto Bay' },
}

Config.SpawnIntervalMs = 8 * 60 * 1000 -- toutes les 8 min si aucun incendie actif
Config.InitialDelayMs = 20000
Config.InteractDistance = 4.0
Config.MarkerDistance = 40.0
Config.ExtinguishTimeMs = 10000

Config.RewardMin = 200
Config.RewardMax = 450

-- Chance qu'une victime soit présente à côté de l'incendie : le sauvetage
-- est comptabilisé automatiquement à l'extinction (pas d'action séparée),
-- pour rester simple.
Config.NpcRescueChancePercent = 40
Config.RescueBonus = 150
