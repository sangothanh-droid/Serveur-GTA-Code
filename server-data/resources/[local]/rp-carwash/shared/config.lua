Config = {}

Config.CarWashes = {
    { coords = vector3(-70.0, -1760.0, 29.5),  label = 'Station-service - Strawberry' },
    { coords = vector3(818.0, -1029.0, 26.4),  label = 'Station-service - La Mesa' },
}

Config.InteractDistance = 3.0
Config.MarkerDistance = 15.0
Config.WashTimeMs = 12000

-- GetVehicleDirtLevel va de 0.0 (impeccable) à 15.0 (très sale).
Config.MinDirtLevel = 3.0

Config.CooldownMs = 120000 -- 2 min avant de relaver le même véhicule (par plaque)

Config.RewardMin = 40
Config.RewardMax = 90
