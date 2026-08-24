Config = {}

Config.TableLocation = vector3(925.0, 46.0, 81.0) -- Diamond Casino & Resort - entrée
Config.InteractDistance = 2.5
Config.MarkerDistance = 15.0

Config.CommandName = 'casino'

Config.MinBet = 50
Config.MaxBet = 2000

-- Avantage maison : une pièce/roulette équitable donnerait 50% de chances de
-- gain pour un paiement x2. Ici le joueur gagne un peu moins souvent et un
-- peu moins gros, pour que le casino reste rentable pour le serveur et ne
-- devienne pas une source d'argent infini.
Config.WinChancePercent = 45
Config.PayoutMultiplier = 1.8

-- --- Machine à sous (/slots) ---
Config.Slots = {
    CommandName = 'slots',
    MinBet = 20,
    MaxBet = 500,
    Symbols = { 'cerise', 'citron', 'cloche', 'étoile', 'sept' },
    -- 3 symboles identiques : ~4% de chance avec 5 symboles équiprobables.
    ThreeMatchMultiplier = 5.0,
    -- 2 symboles identiques : ~48% de chance.
    TwoMatchMultiplier = 1.2,
}

-- --- Blackjack simplifié (/blackjack, /bjhit, /bjstand) ---
Config.Blackjack = {
    CommandName = 'blackjack',
    HitCommandName = 'bjhit',
    StandCommandName = 'bjstand',
    MinBet = 50,
    MaxBet = 1000,
    DealerStandsOn = 17,
}

-- --- Paris hippiques (/horsebet) ---
Config.HorseRace = {
    CommandName = 'horsebet',
    RaceIntervalMs = 5 * 60 * 1000, -- un tirage toutes les 5 min
    MinBet = 20,
    MaxBet = 500,
    -- winChancePercent : poids relatifs utilisés pour tirer UN gagnant par
    -- course (pas des probabilités indépendantes). odds : multiplicateur de
    -- gain si ce cheval gagne. Avantage maison intégré : espérance de gain
    -- < 1 pour chaque cheval (ex: Tornado gagne ~50% du temps mais ne paie
    -- que x1.7, pas x2).
    Horses = {
        { name = 'Tornado',    winChancePercent = 40, odds = 1.7 },
        { name = 'Lucky Star', winChancePercent = 22, odds = 3.0 },
        { name = 'Midnight',   winChancePercent = 12, odds = 5.5 },
        { name = 'Comet',      winChancePercent = 6,  odds = 10.0 },
    },
}
