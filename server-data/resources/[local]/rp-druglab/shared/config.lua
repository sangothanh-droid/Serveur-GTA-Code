Config = {}

Config.Labs = {
    { id = 'druglab_sandy',    coords = vector3(2200.0, 3050.0, 47.0),  label = 'Labo de Meth - Grand Senora' },
    { id = 'druglab_stormdrain', coords = vector3(1000.0, -3000.0, -38.9), label = 'Labo Souterrain - Storm Drain' },
}

Config.InteractDistance = 2.0
Config.MarkerDistance = 15.0
Config.CookTimeMs = 30000

Config.IngredientCost = 400        -- coût des précurseurs pour un non-propriétaire
Config.OwnerDiscountPercent = 50   -- remise pour le gang qui contrôle le labo
Config.NonOwnerFailChancePercent = 25 -- chance d'explosion/échec si on n'est pas propriétaire

Config.YieldMin = 5
Config.YieldMax = 12
Config.PricePerUnit = 120

Config.RepGainPer5Units = 15
Config.PoliceCallChancePercent = 30
