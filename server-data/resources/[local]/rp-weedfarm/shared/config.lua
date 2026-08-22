Config = {}

-- Emplacements de récolte, dans le désert (territoire Culebra Cartel).
Config.PlantSpots = {
    vector3(2170.5, 4780.7, 41.1),
    vector3(2190.2, 4805.3, 41.0),
    vector3(2150.8, 4760.2, 41.2),
    vector3(2205.6, 4770.9, 41.0),
}

Config.RegrowTimeMs = 5 * 60 * 1000 -- 5 min avant repousse d'un plant récolté
Config.YieldPerHarvest = 1
Config.MarkerDistance = 15.0
Config.InteractDistance = 2.0

Config.ProcessPoint = { coords = vector3(2145.0, 4820.0, 40.9), label = 'Labo de conditionnement' }
Config.ProcessTimeMs = 15000
Config.PricePerUnit = 350
Config.RepGainPer5Units = 10
