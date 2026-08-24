Config = {}

Config.BarberShops = {
    { coords = vector3(-32.0, -145.0, 57.0),    label = 'Coiffeur - Hawick' },
    { coords = vector3(139.8, -1708.9, 29.3),   label = 'Coiffeur - Strawberry' },
}

Config.InteractDistance = 2.0
Config.MarkerDistance = 15.0

Config.CommandName = 'barber'
Config.Price = 75

-- SetPedHairColor/SetPedComponentVariation acceptent des index de 0 à 63
-- selon le modèle de ped (voir la doc FiveM natives pour la liste complète).
Config.MaxColorIndex = 63
