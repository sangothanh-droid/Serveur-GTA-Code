Config = {}

Config.MarkerDistance = 20.0
Config.InteractDistance = 2.5

Config.TestDriveTimeMs = 60000       -- durée max d'un essai
Config.TestDriveWanderDistance = 60.0 -- annule l'essai si le joueur s'éloigne trop du véhicule

-- Génération de plaque : préfixe + 5 caractères aléatoires (8 caractères
-- au total, taille max affichée par GTA V). Unicité vérifiée en base
-- avant insertion dans player_vehicles (voir server/main.lua).
Config.PlatePrefix = 'MRP'
Config.PlateChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

-- `deliveryGarage` doit correspondre à un `id` défini dans
-- rp-garage/shared/config.lua : après achat, le véhicule y est déposé
-- (garagé) plutôt que de spawn instantanément à côté du joueur.
Config.Dealerships = {
    {
        id = 'general',
        label = 'Premium Deluxe Motorsport',
        coords = vector3(-56.0, -1096.0, 26.4),
        spawnCoords = vector4(-45.0, -1090.0, 26.4, 70.0),
        vehicleType = 'automobile',
        deliveryGarage = 'legion_square',
    },
    {
        id = 'moto',
        label = 'Southside Bike Shop',
        coords = vector3(-1153.0, -1526.0, 4.4),
        spawnCoords = vector4(-1160.0, -1518.0, 4.4, 140.0),
        vehicleType = 'bike',
        deliveryGarage = 'legion_square',
    },
}

-- Catalogue : modèles vanilla GTA V (spawn codes réels, voir
-- qb-core/shared/vehicles.lua pour la liste officielle complète). `type`
-- filtre quelle(s) concession(s) proposent le véhicule
-- (Dealerships[i].vehicleType).
Config.Catalog = {
    -- Citadines
    { model = 'asea',        label = 'Declasse Asea',              price = 2500,   type = 'automobile' },
    { model = 'glendale',    label = 'Benefactor Glendale',        price = 3400,   type = 'automobile' },
    { model = 'emperor',     label = 'Albany Emperor',             price = 4250,   type = 'automobile' },
    { model = 'issi2',       label = 'Weeny Issi',                 price = 7000,   type = 'automobile' },
    { model = 'club',        label = 'BF Club',                    price = 8000,   type = 'automobile' },

    -- Berlines
    { model = 'asterope',    label = 'Karin Asterope',             price = 11000,  type = 'automobile' },
    { model = 'glendale2',   label = 'Benefactor Glendale Custom', price = 12000,  type = 'automobile' },
    { model = 'fugitive',    label = 'Cheval Fugitive',            price = 20000,  type = 'automobile' },
    { model = 'cog55',       label = 'Enus Cognoscenti 55',        price = 22000,  type = 'automobile' },
    { model = 'cognoscenti', label = 'Enus Cognoscenti',           price = 22500,  type = 'automobile' },

    -- SUV
    { model = 'cavalcade',   label = 'Albany Cavalcade',           price = 14000,  type = 'automobile' },
    { model = 'baller2',     label = 'Gallivanter Baller II',      price = 15000,  type = 'automobile' },
    { model = 'bjxl',        label = 'Karin BeeJay XL',            price = 19000,  type = 'automobile' },
    { model = 'baller',      label = 'Gallivanter Baller',         price = 22000,  type = 'automobile' },
    { model = 'baller4',     label = 'Gallivanter Baller LE LWB',  price = 29000,  type = 'automobile' },

    -- Sportives
    { model = 'buffalo',     label = 'Bravado Buffalo',            price = 18750,  type = 'automobile' },
    { model = 'buffalo2',    label = 'Bravado Buffalo S',          price = 24500,  type = 'automobile' },
    { model = 'bestiagts',   label = 'Grotti Bestia GTS',          price = 37000,  type = 'automobile' },
    { model = 'alpha',       label = 'Albany Alpha',               price = 53000,  type = 'automobile' },
    { model = 'banshee',     label = 'Bravado Banshee',            price = 56000,  type = 'automobile' },
    { model = 'comet2',      label = 'Pfister Comet',              price = 130000, type = 'automobile' },
    { model = 'carbonizzare', label = 'Grotti Carbonizzare',       price = 155000, type = 'automobile' },

    -- Motos
    { model = 'bati2',       label = 'Pegassi Bati 801RR',         price = 19000,  type = 'bike' },
    { model = 'avarus',      label = 'LCC Avarus',                 price = 20000,  type = 'bike' },
    { model = 'bati',        label = 'Pegassi Bati 801',           price = 24000,  type = 'bike' },
}
