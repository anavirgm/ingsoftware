-- MariaDB dump 10.19  Distrib 10.4.28-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: camicandy
-- ------------------------------------------------------
-- Server version	11.2.0-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `direccion` varchar(80) NOT NULL,
  `telefono` varchar(16) NOT NULL,
  `cedula` varchar(12) NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `cedula_UNIQUE` (`cedula`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Antonio Villalobos','Maracaibo','04145554565','30643276',1),(2,'Samuel Rincon','Los Olivos','04125555555','29888888',1),(3,'Juan Urdaneta','C2','04146074412','29999999',1),(4,'Pedro Pérez','Av. Bolívar','04141234567','20765432',1),(5,'María Gómez','Calle Principal','04142222222','29876543',1),(6,'José Martínez','Urb. El Recreo','04143333333','30456789',1),(7,'Ana Rodríguez','Av. Libertador','04144444444','30123456',1),(8,'Carlos Sánchez','Calle 8','04145555555','30234567',1),(9,'Laura González','Av. Fuerzas Armadas','04146666666','30987654',1),(10,'Miguel López','Av. Universidad','04147777777','30876543',1),(11,'Verónica Jiménez','Calle 5','04148888888','30765432',1),(12,'Juan Pérez','Av. Bella Vista','04149999999','30654321',1),(13,'Martha Suárez','Av. El Milagro','04141010101','30543210',1),(14,'Roberto Medina','Av. La Limpia','04141111111','30432109',1),(15,'Sofía Ramírez','Av. Delicias','04141222222','30321098',1),(16,'Andrés Hernández','Av. 5 de Julio','04141333333','30210987',1),(17,'Lucía Castro','Av. Goajira','04141444444','30109876',1),(18,'Manuel Vargas','Av. Universidad','04141555555','31234567',1),(19,'Daniela Navarro','Av. Fuerzas Armadas','04141666666','31123456',1),(20,'Héctor Mendoza','Calle 72','04141777777','31012345',1),(21,'Patricia Ruiz','Av. Bella Vista','04141888888','31987654',1),(22,'Ramón López','Av. El Milagro','04141999999','31876543',1),(23,'Isabel Medina','Av. La Limpia','04142010101','31765432',1),(24,'Marcos Ramírez','Av. Delicias','04142111111','31654321',1);
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `productos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) NOT NULL,
  `fecha_de_vencimiento` date NOT NULL,
  `cantidad_disponible` int(3) NOT NULL,
  `imagen` longblob DEFAULT NULL,
  `precio_en_dolares` decimal(4,2) NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'Vainilla','2024-07-18',10,NULL,2.00,1),(2,'Chocolate','2024-07-31',77,NULL,3.00,1),(3,'Fresa','2024-12-31',50,NULL,5.99,1),(4,'Mango','2024-12-31',44,NULL,6.50,1),(5,'Limón','2024-12-31',55,NULL,4.75,1),(6,'Piña','2024-12-31',60,NULL,4.25,1),(7,'Coco','2024-12-31',38,NULL,7.25,1),(8,'Cambur','2024-12-31',67,NULL,4.99,1),(9,'Mora','2024-12-31',52,NULL,6.75,1),(10,'Uva','2024-12-31',58,NULL,5.50,1),(11,'Durazno','2024-12-31',58,NULL,5.25,1),(12,'Manzana','2024-12-31',72,NULL,4.50,1),(13,'Sandía','2024-12-31',30,NULL,3.99,1),(14,'Melón','2024-12-31',43,NULL,4.80,1),(15,'Cereza','2024-12-31',53,NULL,6.20,1),(16,'Naranja','2024-12-31',62,NULL,4.95,1),(17,'Kiwi','2024-12-31',38,NULL,6.99,1),(18,'Pera','2024-12-31',55,NULL,5.75,1),(19,'Papaya','2024-12-31',45,NULL,5.40,1),(20,'Guayaba','2024-12-31',55,NULL,6.40,1),(21,'Granada','2024-12-31',57,NULL,6.60,1),(22,'Lima','2024-12-31',45,NULL,5.20,1);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `proveedores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `rif` varchar(12) NOT NULL,
  `direccion` varchar(80) NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idproveedores_UNIQUE` (`id`),
  UNIQUE KEY `rif_UNIQUE` (`rif`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
INSERT INTO `proveedores` VALUES (1,'Helados Tio Rico','J-88888888','Caracas',1),(2,'Helados La Argentina','J-99999999','Av. 5 de Julio',1),(3,'Helados Carabobo','J-87654324','Carabobo',1),(4,'Distribuidora Helados del Este','J-76543210','Av. Libertador',1),(5,'Helados Hermanos Gómez','J-23456789','Maracay',1),(6,'Helados El Criollo','J-13579246','Valencia',1),(7,'Frío Gelato C.A.','J-98765432','Maracaibo',1),(8,'Helados El Potro','J-24680135','Barquisimeto',1),(9,'Helados del Zulia','J-67584930','San Francisco',1),(10,'La Heladería Artesanal','J-19283746','Puerto La Cruz',1),(11,'Helados Ricos y Sabrosos','J-57382910','Mérida',1),(12,'Distribuidora de Helados Guayana','J-38475629','Ciudad Guayana',1),(13,'Helados Frescos y Naturales','J-10293847','Punto Fijo',1),(14,'El Heladero Venezolano','J-29384756','Los Teques',1),(15,'Helados del Cacao','J-47582930','Cumaná',1),(16,'Fábrica de Helados Santa Rita','J-38592017','Santa Rita',1),(17,'Helados del Táchira','J-28374659','San Cristóbal',1),(18,'Helados Sabores del Llano','J-50394827','Barinas',1),(19,'La Heladería de la Familia','J-83746592','Guacara',1),(20,'Helados Caseros Don José','J-12938475','La Victoria',1),(21,'Distribuidora Helados Maracay','J-37485920','Maracay',1),(22,'Helados Arcoíris C.A.','J-59483720','Valencia',1),(23,'Helados del Pueblo','J-47382915','San Felipe',1);
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transacciones`
--

DROP TABLE IF EXISTS `transacciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transacciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `marca_de_tiempo` timestamp NOT NULL,
  `importe_en_dolares` decimal(5,2) DEFAULT NULL,
  `tasa_bcv` decimal(6,2) unsigned NOT NULL,
  `clientes_id` int(11) DEFAULT NULL,
  `proveedores_id` int(11) DEFAULT NULL,
  `usuarios_id` int(11) NOT NULL,
  PRIMARY KEY (`id`,`usuarios_id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_transacciones_clientes1_idx` (`clientes_id`),
  KEY `fk_transacciones_proveedores1_idx` (`proveedores_id`),
  KEY `fk_transacciones_usuarios1_idx` (`usuarios_id`),
  CONSTRAINT `fk_transacciones_clientes1` FOREIGN KEY (`clientes_id`) REFERENCES `clientes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_transacciones_proveedores1` FOREIGN KEY (`proveedores_id`) REFERENCES `proveedores` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_transacciones_usuarios1` FOREIGN KEY (`usuarios_id`) REFERENCES `usuarios` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='* Falta añadir un trigger o un CHECK para revisar que sólo clientes_id o proveedores_id es NULL pero no ambos\\\\n* También falta verificar que sólo el administrador puede registrar una compra\\\\n* columna monto: Si es positivo la transacción fue una venta a un cliente, si es negativo fue una compra a un proveedor';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transacciones`
--

LOCK TABLES `transacciones` WRITE;
/*!40000 ALTER TABLE `transacciones` DISABLE KEYS */;
INSERT INTO `transacciones` VALUES (1,'2024-07-02 03:53:00',487.20,36.49,NULL,1,1),(2,'2024-07-08 03:58:00',25.00,36.49,16,NULL,1),(3,'2024-07-07 04:04:00',6.96,36.49,1,NULL,1),(4,'2024-07-08 04:05:00',21.46,36.49,11,NULL,1),(5,'2024-07-08 04:05:00',44.14,36.49,17,NULL,1),(6,'2024-07-08 04:39:18',43.62,36.39,NULL,7,1),(7,'2024-07-09 04:40:34',84.94,36.49,NULL,16,1),(8,'2024-07-09 04:40:34',13.92,36.49,NULL,15,1),(9,'2024-07-09 04:40:34',41.88,36.49,NULL,2,1),(10,'2024-07-09 04:40:34',74.24,36.49,NULL,9,1),(11,'2024-07-10 04:43:00',13.34,36.49,22,NULL,1),(12,'2024-07-10 04:44:00',13.05,36.49,2,NULL,1),(13,'2024-07-10 04:44:00',33.64,36.49,13,NULL,1),(14,'2024-07-18 04:53:00',24.36,36.51,1,NULL,1),(15,'2024-07-17 15:23:00',13.91,36.54,5,NULL,1),(16,'2024-07-16 15:23:00',9.86,36.54,10,NULL,1),(17,'2024-07-18 15:24:00',5.51,36.54,1,NULL,1);
/*!40000 ALTER TABLE `transacciones` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_admin_compra` BEFORE INSERT ON `transacciones` FOR EACH ROW BEGIN

    IF NEW.importe_en_dolares < 0 AND NEW.usuarios_id NOT IN (SELECT id FROM usuarios WHERE rol = 'administrador') THEN

        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Solo el administrador puede registrar una compra.';

    END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validar_clientes_proveedores` BEFORE INSERT ON `transacciones` FOR EACH ROW BEGIN

    IF (NEW.clientes_id IS NULL AND NEW.proveedores_id IS NULL) OR (NEW.clientes_id IS NOT NULL AND NEW.proveedores_id IS NOT NULL) THEN

        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: clientes_id y proveedores_id no pueden ser ambos NULL o ambos diferentes de NULL.';

    END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validar_monto` BEFORE INSERT ON `transacciones` FOR EACH ROW BEGIN

    IF (NEW.importe_en_dolares > 0 AND

    NEW.proveedores_id IS NOT NULL) THEN

        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El importe de una compra no puede ser positivo.';

    ELSEIF (NEW.importe_en_dolares < 0 AND NEW.clientes_id IS NOT NULL) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El importe de una venta no puede ser negativo.';

    END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `transacciones_tiene_productos`
--

DROP TABLE IF EXISTS `transacciones_tiene_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transacciones_tiene_productos` (
  `transacciones_id` int(11) NOT NULL,
  `productos_id` int(11) NOT NULL,
  `cantidad` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transacciones_tiene_productos`
--

LOCK TABLES `transacciones_tiene_productos` WRITE;
/*!40000 ALTER TABLE `transacciones_tiene_productos` DISABLE KEYS */;
INSERT INTO `transacciones_tiene_productos` VALUES (1,1,60),(1,2,80),(2,22,2),(2,19,1),(2,18,1),(3,2,2),(4,1,4),(4,4,1),(5,7,4),(5,6,1),(5,14,1),(6,20,4),(6,2,4),(7,8,2),(7,7,7),(7,4,1),(7,3,1),(8,2,4),(9,5,2),(9,6,4),(9,14,2),(10,10,10),(10,12,2),(11,7,1),(11,6,1),(12,5,1),(12,4,1),(13,7,4),(14,2,7),(15,2,2),(15,3,1),(16,6,2),(17,5,1);
/*!40000 ALTER TABLE `transacciones_tiene_productos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `actualizar_stock_monto` AFTER INSERT ON `transacciones_tiene_productos` FOR EACH ROW BEGIN
    DECLARE total_amount DECIMAL(10, 2);
    DECLARE es_compra BOOLEAN;

    
    SELECT (t.clientes_id IS NULL) INTO es_compra FROM transacciones t WHERE t.id = NEW.transacciones_id;

    
    IF es_compra THEN
        
        UPDATE productos SET cantidad_disponible = cantidad_disponible + NEW.cantidad WHERE id = NEW.productos_id;
    ELSE
        
        UPDATE productos SET cantidad_disponible = cantidad_disponible - NEW.cantidad WHERE id = NEW.productos_id;
    END IF;

    
    SELECT SUM(tp.cantidad * p.precio_en_dolares) * 1.16 INTO total_amount
    FROM transacciones_tiene_productos tp
    JOIN productos p ON tp.productos_id = p.id
    WHERE tp.transacciones_id = NEW.transacciones_id;

    
    UPDATE transacciones SET importe_en_dolares = total_amount WHERE id = NEW.transacciones_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cedula` varchar(12) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `rol` enum('empleado','administrador') NOT NULL,
  `hash_de_contrasena` varchar(60) NOT NULL,
  `pregunta_seguridad` enum('¿Cuándo es tu cumpleaños?','¿A qué secundaria fuiste?','¿Cómo se llamaba tu mamá?','¿Cuál es tu postre favorito?') NOT NULL,
  `respuesta_seguridad` varchar(60) NOT NULL,
  `status` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idusuarios_UNIQUE` (`id`),
  UNIQUE KEY `cedula_UNIQUE` (`cedula`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'30597012','Ana Mota','administrador','$2b$12$L83bWlRfyz9/KODyRWF1d.uksvrr4O9mX9q0p2Q7RT3xVVNHn55RS','¿Cuál es tu postre favorito?','$2y$10$wdKk9e/y5sSN2tTwMQ0ux.q9cwkhsfwTo4nO1Zt4dK9Dmv0Qn/.1S',1),(2,'29877987','Samuel Rincon','empleado','$2b$12$v0/S73aOSgMLNMqY1joW6uIT2RtBO/NrfHEM9rd/zn4a9IpIAg2oS','¿Cuál es tu postre favorito?','$2b$12$rOpp6x4G2vQUFdrrtwO.DOabA4YrGjeUMoTqkAoordE70JBNqG1NG',1),(3,'31575257','Juan Urdaneta','empleado','$2b$12$/c1gm3lEVMZp1bypsdLyK.5oDXgsXGcZQ2SAL2K6wHxzE17N/m.bu','¿Cuál es tu postre favorito?','$2b$12$eQpp7thlc.If7LruajoyJO9i8v8tn2jTomQLw7yw7/gJ/lCUz0uym',0);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-18 13:31:55
