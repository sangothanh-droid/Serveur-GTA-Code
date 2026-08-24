Config = {}

-- Pool de maisons candidates, plus large que le nombre affiché en même
-- temps (voir Config.ActiveCount) pour limiter le farming.
Config.HousePool = {
    vector3(-1080.0, -880.0, 4.9),
    vector3(-1400.0, -700.0, 26.0),
    vector3(90.0, -1900.0, 21.0),
    vector3(1080.0, -1300.0, 34.0),
    vector3(-280.0, -1700.0, 30.5),
    vector3(2400.0, 4400.0, 40.0),
    vector3(-3200.0, 1000.0, 15.0),
    vector3(-100.0, 1900.0, 205.0),
    vector3(1900.0, 3800.0, 32.0),
    vector3(120.0, 380.0, 108.0),
}

Config.ActiveCount = 3            -- nombre de maisons "vides" actives en même temps
Config.RotationIntervalMs = 15 * 60 * 1000 -- rotation du pool toutes les 15 min

Config.InteractDistance = 2.5
Config.MarkerDistance = 20.0
Config.SearchTimeMs = 12000
Config.CooldownMs = 10 * 60 * 1000 -- 10 min avant de refaire la même maison (indépendant de la rotation)

Config.LootMin = 200
Config.LootMax = 900
Config.RepGain = 8
Config.PoliceCallChancePercent = 25
