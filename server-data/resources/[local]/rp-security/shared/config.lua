Config = {}

Config.JobName = 'security' -- voir docs/qb-core-jobs-snippet.lua

Config.PatrolSites = {
    { coords = vector3(147.0, -1044.0, 29.37), radius = 40.0, label = 'Banque - Legion Square' },
    { coords = vector3(-1447.0, -239.0, 49.8), radius = 60.0, label = 'Centre commercial - Del Perro' },
}

Config.TickMs = 5 * 60 * 1000 -- paiement toutes les 5 min de présence sur site
Config.PayPerTick = 150
