CREATE TABLE IF NOT EXISTS `gang_reputation` (
  `gang_name` VARCHAR(50) NOT NULL,
  `reputation` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`gang_name`)
);
