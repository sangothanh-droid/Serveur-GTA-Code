Config = {}

Config.JobName = 'realestate' -- voir docs/qb-core-jobs-snippet.lua

Config.Properties = {
    { coords = vector3(-800.0, 300.0, 100.0), radius = 50.0, label = 'Villas - Vinewood Hills' },
    { coords = vector3(-560.0, -50.0, 40.0),  radius = 50.0, label = 'Appartements - Rockford Hills' },
}

Config.TickMs = 5 * 60 * 1000 -- paiement toutes les 5 min de présence sur site
Config.PayPerTick = 180
