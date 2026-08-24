CREATE TABLE IF NOT EXISTS `street_reputation` (
  `citizenid` varchar(50) NOT NULL,
  `reputation` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
