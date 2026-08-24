-- Table manquante : rp-carjack et rp-lonewolfcarjack interrogent déjà
-- `player_vehicles` (SELECT 1 FROM player_vehicles WHERE plate = ?) mais
-- elle n'existe ni dans qb-core/qbcore.sql ni en base — elle n'a jamais
-- été créée. Ce fichier la définit avec des colonnes standard QBCore,
-- compatibles avec les requêtes déjà existantes.
CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL,
  `vehicle` varchar(50) NOT NULL,
  `hash` varchar(50) NOT NULL,
  `plate` varchar(15) NOT NULL,
  `garage` varchar(50) DEFAULT NULL,
  `state` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
