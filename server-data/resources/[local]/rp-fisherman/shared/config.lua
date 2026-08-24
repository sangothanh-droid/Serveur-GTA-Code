Config = {}

Config.FishingSpots = {
    vector3(-1780.0, -1200.0, 1.5),  -- Chumash
    vector3(-3420.0, 980.0, 5.0),    -- Cassidy Creek
    vector3(-270.0, 6640.0, 7.5),    -- Paleto Cove
    vector3(3820.0, 4440.0, 3.0),    -- côte est
}

Config.InteractDistance = 2.0
Config.MarkerDistance = 15.0
Config.FishTimeMs = 10000
Config.RegrowTimeMs = 2 * 60 * 1000 -- 2 min avant qu'un spot reproduise du poisson
Config.YieldPerCatch = 1

Config.Market = { coords = vector3(-1580.0, -930.0, 13.0), label = 'Marché aux poissons - Del Perro' }
Config.PricePerUnit = 45
