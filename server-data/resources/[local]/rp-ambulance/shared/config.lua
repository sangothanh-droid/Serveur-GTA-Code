Config = {}

Config.JobName = 'ambulance' -- job par défaut de QBCore (qb-core/shared/jobs.lua), aucun ajout requis

Config.Hospital = { coords = vector3(298.7, -584.7, 43.3), label = 'Pillbox Hill Medical Center' }
Config.SpawnVehicleModel = 'ambulance'
Config.SpawnDistance = 5.0

Config.ReviveDistance = 3.0
Config.ReviveHealth = 150 -- santé rendue après un /revive

Config.HealDistance = 3.0
Config.HealAmount = 200   -- santé max standard d'un ped joueur
Config.HealCost = 50      -- payé par le joueur soigné à l'ambulancier (gratuit s'il n'a pas assez de cash)
