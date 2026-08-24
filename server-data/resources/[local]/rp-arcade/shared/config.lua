Config = {}

Config.Machines = {
    { coords = vector3(-1091.0, -1749.0, 4.4), label = 'Borne Arcade - Ammu-Nation Vespucci' },
    { coords = vector3(-3245.0, 1000.0, 12.8), label = 'Borne Arcade - Bar de Chumash' },
}

Config.InteractDistance = 1.5
Config.MarkerDistance = 10.0

Config.MinDelayMs = 1500  -- délai aléatoire avant le signal "GO"
Config.MaxDelayMs = 4000
Config.ReactionTimeoutMs = 3000 -- temps max pour réagir après le signal
Config.MaxReactionMs = 400     -- doit réagir en moins de 400ms pour gagner

Config.Reward = 40
Config.CooldownMs = 15000 -- par joueur, entre deux tentatives
