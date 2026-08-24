Config = {}

-- Toutes les activités de ce fichier sont réservées aux joueurs qui
-- n'appartiennent à AUCUN des 5 gangs officiels (voir rp-crime-core:GetPlayerGang).
-- Un joueur de gang doit utiliser les activités liées aux gangs (rp-shoprobbery,
-- rp-carjack, etc.) ; il ne peut pas cumuler les deux systèmes.

Config.Pickpocket = {
    CommandName = 'pickpocket',
    NpcSearchRadius = 5.0,
    CooldownMs = 45000,
    SuccessChancePercent = 60,
    PoliceCallChancePercent = 15,
    RewardMin = 20,
    RewardMax = 80,
    RepGain = 3,
}

Config.CarBreakIn = {
    Locations = {
        vector3(-1197.0, -1571.0, 4.6),
        vector3(-260.0, -970.0, 31.2),
        vector3(1015.0, -93.0, 74.6),
        vector3(-540.0, -190.0, 38.1),
    },
    InteractDistance = 2.0,
    MarkerDistance = 15.0,
    BreakInTimeMs = 5000,
    CooldownMs = 180000, -- 3 min avant de refaire le même point
    RewardMin = 40,
    RewardMax = 150,
    RepGain = 4,
    PoliceCallChancePercent = 20,
}

Config.MailboxTheft = {
    Locations = {
        vector3(-273.0, -958.0, 31.2),
        vector3(-1150.0, -1520.0, 4.6),
        vector3(543.0, -180.0, 57.0),
    },
    InteractDistance = 1.5,
    MarkerDistance = 10.0,
    SearchTimeMs = 3000,
    CooldownMs = 120000, -- 2 min avant de refaire la même boîte
    RewardMin = 15,
    RewardMax = 60,
    RepGain = 2,
    PoliceCallChancePercent = 10,
}

Config.Graffiti = {
    Walls = {
        vector3(-140.0, -1620.0, 34.0),
        vector3(430.0, -1930.0, 25.5),
        vector3(-1100.0, -1420.0, 4.6),
    },
    InteractDistance = 2.0,
    MarkerDistance = 10.0,
    TagTimeMs = 8000,
    CooldownMs = 300000, -- 5 min avant de retagger le même mur
    RewardMin = 10,
    RewardMax = 30,
    RepGain = 6, -- surtout un coup de projecteur sur la réputation, peu d'argent
    PoliceCallChancePercent = 15,
}
