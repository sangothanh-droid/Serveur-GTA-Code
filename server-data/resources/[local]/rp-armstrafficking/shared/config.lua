Config = {}

Config.DealPoint = { coords = vector3(2497.7, 4213.5, 38.4), label = 'Point de rendez-vous - Grand Senora Desert' }
Config.InteractDistance = 10.0

Config.DealIntervalMs = 5 * 60 * 1000 -- 5 min entre deux deals pour un même joueur

-- Chance de base d'une embuscade, multipliée par le "policeMultiplier" du
-- palier de réputation du gang (voir rp-gangs/shared/config.lua) : plus le
-- gang est connu, plus le fournisseur est surveillé.
Config.AmbushBaseChancePercent = 10

Config.RewardMin = 1000
Config.RewardMax = 4000
Config.RepGain = 25
