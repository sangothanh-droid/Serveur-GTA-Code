Config = {}

-- Façade dans le territoire des Antonelli (Rockford Hills / Vinewood Hills)
Config.Front = { coords = vector3(-620.0, -30.0, 38.0), label = 'Blanchisserie Antonelli' }
Config.InteractDistance = 10.0

Config.ItemName = 'dirty_cash' -- à ajouter à qb-core/shared/items.lua, voir docs/qb-core-items-snippet.lua

Config.MinAmount = 100
Config.MaxAmount = 5000
Config.CutPercent = 20          -- commission prélevée par la façade
Config.AuditChancePercent = 15  -- chance qu'un contrôle déclenche une alerte police
Config.RepGainPer1000 = 5
