Config = {}

Config.Banks = {
    { coords = vector3(147.0, -1044.0, 29.37),     label = 'Fleeca Legion Square' },
    { coords = vector3(-351.17, -49.65, 49.04),    label = 'Fleeca Milton Road' },
    { coords = vector3(-1212.98, -336.75, 37.78),  label = 'Fleeca Morningwood' },
}

Config.MarkerDistance = 15.0
Config.InteractDistance = 2.0

Config.HackTimeMs = 20000    -- neutraliser l'alarme
Config.DrillTimeMs = 45000   -- percer le coffre
Config.CooldownMs = 45 * 60 * 1000 -- 45 min avant de rebraquer la même banque

Config.MinPoliceOnline = 1 -- braquage impossible si aucun policier en service

Config.RewardMin = 5000
Config.RewardMax = 15000
Config.RepGain = 60
