Config = {}

Config.JobName = 'dj' -- voir docs/qb-core-jobs-snippet.lua

Config.Club = { coords = vector3(-1387.0, -583.0, 30.3), radius = 40.0, label = 'Bahama Mamas - Vinewood' }
Config.CommandName = 'ambiance'

Config.DurationMs = 10 * 60 * 1000  -- durée de l'ambiance (10 min)
Config.TickMs = 60000               -- versement du bonus toutes les 60s
Config.CooldownMs = 15 * 60 * 1000  -- 15 min avant qu'un DJ relance une ambiance
Config.BonusPerTick = 20
