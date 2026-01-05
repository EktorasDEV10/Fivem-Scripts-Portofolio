CREATE TABLE IF NOT EXISTS `warehouses` (
  `identifier` varchar(250) DEFAULT NULL,
  `password` int(10) DEFAULT NULL,
  `x` longtext DEFAULT NULL,
  `y` longtext DEFAULT NULL,
  `z` longtext DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `steamName` varchar(50) DEFAULT NULL,
  `moving` int(11) DEFAULT 0);

CREATE TABLE IF NOT EXISTS `warehouse_items` (
  `identifier` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `password` int(11) DEFAULT NULL,
  `item` varchar(50) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL);

CREATE TABLE IF NOT EXISTS `warehouse_weapons` (
  `identifier` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `password` int(11) DEFAULT NULL,
  `weapon` varchar(50) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL);