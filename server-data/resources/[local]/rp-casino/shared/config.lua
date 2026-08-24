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
