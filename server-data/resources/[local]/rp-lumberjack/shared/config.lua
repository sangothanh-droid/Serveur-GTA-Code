Config = {}

-- Zone forestière près de Paleto Bay.
Config.Trees = {
    vector3(-450.0, 5900.0, 65.0),
    vector3(-480.0, 5950.0, 68.0),
    vector3(-420.0, 5980.0, 70.0),
    vector3(-500.0, 6020.0, 66.0),
    vector3(-390.0, 6000.0, 71.0),
}

Config.InteractDistance = 2.0
Config.MarkerDistance = 15.0
Config.ChopTimeMs = 8000
Config.RegrowTimeMs = 4 * 60 * 1000 -- 4 min avant repousse d'un arbre coupé
Config.YieldPerChop = 1

Config.Sawmill = { coords = vector3(-580.0, 5730.0, 75.0), label = 'Scierie de Paleto' }
Config.PricePerUnit = 60
