Config = {}

Config.Routes = {
    [1] = {
        label = 'Circuit Vinewood',
        checkpoints = {
            vector3(-200.0, 250.0, 90.0),
            vector3(-600.0, 20.0, 40.0),
            vector3(-1100.0, -450.0, 30.0),
            vector3(-800.0, -900.0, 30.0),
            vector3(-200.0, -800.0, 40.0),
            vector3(-200.0, 250.0, 90.0), -- retour au départ
        },
    },
}

Config.CheckpointRadius = 5.0
Config.JoinWindowSeconds = 30

Config.RewardMin = 500
Config.RewardMax = 1000
Config.RepGain = 10
