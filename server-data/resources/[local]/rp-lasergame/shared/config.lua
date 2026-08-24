Config = {}

Config.Arena = { coords = vector3(-190.0, -2650.0, 6.0), radius = 60.0, label = 'Arène Laser Game - Elysian Island' }

Config.CommandName = 'lasergame' -- /lasergame start | join

Config.JoinWindowMs = 30000       -- 30s pour rejoindre après /lasergame start
Config.SessionDurationMs = 3 * 60 * 1000 -- 3 min de jeu
Config.MinParticipants = 2

Config.TagRange = 3.0
Config.TagCooldownMs = 2000       -- anti-spam entre deux tags sur la même cible

Config.RewardTop = 200            -- au(x) meilleur(s) score(s), à la fin
