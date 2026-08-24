Config = {}

-- Zones de combat désignées où les cibles apparaissent (terrains vagues,
-- carrière, docks... loin des zones civiles denses).
Config.CombatZones = {
    { coords = vector3(2950.0, 2790.0, 40.0), label = 'Carrière de Grand Senora' },
    { coords = vector3(-190.0, -2650.0, 6.0), label = 'Docks de Elysian Island' },
    { coords = vector3(2050.0, 3130.0, 47.0), label = 'Piste clandestine du désert' },
}

Config.SpawnIntervalMs = 20 * 60 * 1000 -- toutes les 20 min si aucune cible active
Config.InitialDelayMs = 30000           -- délai avant la première cible au démarrage du serveur
Config.HuntTimeMs = 15000               -- durée de l'affrontement (progressbar)
Config.InteractDistance = 5.0
Config.BlipRenderDistance = 40.0        -- distance à partir de laquelle le marqueur au sol s'affiche

Config.RewardMin = 600
Config.RewardMax = 1800
Config.RepGain = 30
