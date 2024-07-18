-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-07-2024 a las 17:43:56
-- Versión del servidor: 11.2.0-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `camicandy`
--
CREATE DATABASE IF NOT EXISTS `camicandy` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `camicandy`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `direccion` varchar(80) NOT NULL,
  `telefono` varchar(16) NOT NULL,
  `cedula` varchar(12) NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `nombre`, `direccion`, `telefono`, `cedula`, `status`) VALUES
(1, 'Antonio Villalobos', 'Maracaibo', '04145554565', '30643276', 1),
(2, 'Samuel Rincon', 'Los Olivos', '04125555555', '29888888', 1),
(3, 'Juan Urdaneta', 'C2', '04146074412', '29999999', 1),
(4, 'Pedro Pérez', 'Av. Bolívar', '04141234567', '20765432', 1),
(5, 'María Gómez', 'Calle Principal', '04142222222', '29876543', 1),
(6, 'José Martínez', 'Urb. El Recreo', '04143333333', '30456789', 1),
(7, 'Ana Rodríguez', 'Av. Libertador', '04144444444', '30123456', 1),
(8, 'Carlos Sánchez', 'Calle 8', '04145555555', '30234567', 1),
(9, 'Laura González', 'Av. Fuerzas Armadas', '04146666666', '30987654', 1),
(10, 'Miguel López', 'Av. Universidad', '04147777777', '30876543', 1),
(11, 'Verónica Jiménez', 'Calle 5', '04148888888', '30765432', 1),
(12, 'Juan Pérez', 'Av. Bella Vista', '04149999999', '30654321', 1),
(13, 'Martha Suárez', 'Av. El Milagro', '04141010101', '30543210', 1),
(14, 'Roberto Medina', 'Av. La Limpia', '04141111111', '30432109', 1),
(15, 'Sofía Ramírez', 'Av. Delicias', '04141222222', '30321098', 1),
(16, 'Andrés Hernández', 'Av. 5 de Julio', '04141333333', '30210987', 1),
(17, 'Lucía Castro', 'Av. Goajira', '04141444444', '30109876', 1),
(18, 'Manuel Vargas', 'Av. Universidad', '04141555555', '31234567', 1),
(19, 'Daniela Navarro', 'Av. Fuerzas Armadas', '04141666666', '31123456', 1),
(20, 'Héctor Mendoza', 'Calle 72', '04141777777', '31012345', 1),
(21, 'Patricia Ruiz', 'Av. Bella Vista', '04141888888', '31987654', 1),
(22, 'Ramón López', 'Av. El Milagro', '04141999999', '31876543', 1),
(23, 'Isabel Medina', 'Av. La Limpia', '04142010101', '31765432', 1),
(24, 'Marcos Ramírez', 'Av. Delicias', '04142111111', '31654321', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `fecha_de_vencimiento` date NOT NULL,
  `cantidad_disponible` int(3) NOT NULL,
  `imagen` longblob DEFAULT NULL,
  `precio_en_dolares` decimal(4,2) NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `fecha_de_vencimiento`, `cantidad_disponible`, `imagen`, `precio_en_dolares`, `status`) VALUES
(1, 'Vainilla', '2024-07-18', 10, NULL, 2.00, 1),
(2, 'Chocolate', '2024-07-31', 77, NULL, 3.00, 1),
(3, 'Fresa', '2024-12-31', 50, NULL, 5.99, 1),
(4, 'Mango', '2024-12-31', 44, NULL, 6.50, 1),
(5, 'Limón', '2024-12-31', 55, NULL, 4.75, 1),
(6, 'Piña', '2024-12-31', 60, NULL, 4.25, 1),
(7, 'Coco', '2024-12-31', 38, NULL, 7.25, 1),
(8, 'Cambur', '2024-12-31', 67, NULL, 4.99, 1),
(9, 'Mora', '2024-12-31', 52, NULL, 6.75, 1),
(10, 'Uva', '2024-12-31', 58, NULL, 5.50, 1),
(11, 'Durazno', '2024-12-31', 58, NULL, 5.25, 1),
(12, 'Manzana', '2024-12-31', 72, NULL, 4.50, 1),
(13, 'Sandía', '2024-12-31', 30, NULL, 3.99, 1),
(14, 'Melón', '2024-12-31', 43, NULL, 4.80, 1),
(15, 'Cereza', '2024-12-31', 53, NULL, 6.20, 1),
(16, 'Naranja', '2024-12-31', 62, NULL, 4.95, 1),
(17, 'Kiwi', '2024-12-31', 38, NULL, 6.99, 1),
(18, 'Pera', '2024-12-31', 55, NULL, 5.75, 1),
(19, 'Papaya', '2024-12-31', 45, NULL, 5.40, 1),
(20, 'Guayaba', '2024-12-31', 55, NULL, 6.40, 1),
(21, 'Granada', '2024-12-31', 57, NULL, 6.60, 1),
(22, 'Lima', '2024-12-31', 45, NULL, 5.20, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `rif` varchar(12) NOT NULL,
  `direccion` varchar(80) NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id`, `nombre`, `rif`, `direccion`, `status`) VALUES
(1, 'Helados Tio Rico', 'J-88888888', 'Caracas', 1),
(2, 'Helados La Argentina', 'J-99999999', 'Av. 5 de Julio', 1),
(3, 'Helados Carabobo', 'J-87654324', 'Carabobo', 1),
(4, 'Distribuidora Helados del Este', 'J-76543210', 'Av. Libertador', 1),
(5, 'Helados Hermanos Gómez', 'J-23456789', 'Maracay', 1),
(6, 'Helados El Criollo', 'J-13579246', 'Valencia', 1),
(7, 'Frío Gelato C.A.', 'J-98765432', 'Maracaibo', 1),
(8, 'Helados El Potro', 'J-24680135', 'Barquisimeto', 1),
(9, 'Helados del Zulia', 'J-67584930', 'San Francisco', 1),
(10, 'La Heladería Artesanal', 'J-19283746', 'Puerto La Cruz', 1),
(11, 'Helados Ricos y Sabrosos', 'J-57382910', 'Mérida', 1),
(12, 'Distribuidora de Helados Guayana', 'J-38475629', 'Ciudad Guayana', 1),
(13, 'Helados Frescos y Naturales', 'J-10293847', 'Punto Fijo', 1),
(14, 'El Heladero Venezolano', 'J-29384756', 'Los Teques', 1),
(15, 'Helados del Cacao', 'J-47582930', 'Cumaná', 1),
(16, 'Fábrica de Helados Santa Rita', 'J-38592017', 'Santa Rita', 1),
(17, 'Helados del Táchira', 'J-28374659', 'San Cristóbal', 1),
(18, 'Helados Sabores del Llano', 'J-50394827', 'Barinas', 1),
(19, 'La Heladería de la Familia', 'J-83746592', 'Guacara', 1),
(20, 'Helados Caseros Don José', 'J-12938475', 'La Victoria', 1),
(21, 'Distribuidora Helados Maracay', 'J-37485920', 'Maracay', 1),
(22, 'Helados Arcoíris C.A.', 'J-59483720', 'Valencia', 1),
(23, 'Helados del Pueblo', 'J-47382915', 'San Felipe', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transacciones`
--

CREATE TABLE `transacciones` (
  `id` int(11) NOT NULL,
  `marca_de_tiempo` timestamp NOT NULL,
  `importe_en_dolares` decimal(5,2) DEFAULT NULL,
  `tasa_bcv` decimal(6,2) UNSIGNED NOT NULL,
  `clientes_id` int(11) DEFAULT NULL,
  `proveedores_id` int(11) DEFAULT NULL,
  `usuarios_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='* Falta añadir un trigger o un CHECK para revisar que sólo clientes_id o proveedores_id es NULL pero no ambos\\\\n* También falta verificar que sólo el administrador puede registrar una compra\\\\n* columna monto: Si es positivo la transacción fue una venta a un cliente, si es negativo fue una compra a un proveedor';

--
-- Volcado de datos para la tabla `transacciones`
--

INSERT INTO `transacciones` (`id`, `marca_de_tiempo`, `importe_en_dolares`, `tasa_bcv`, `clientes_id`, `proveedores_id`, `usuarios_id`) VALUES
(1, '2024-07-02 03:53:00', 487.20, 36.49, NULL, 1, 1),
(2, '2024-07-08 03:58:00', 25.00, 36.49, 16, NULL, 1),
(3, '2024-07-07 04:04:00', 6.96, 36.49, 1, NULL, 1),
(4, '2024-07-08 04:05:00', 21.46, 36.49, 11, NULL, 1),
(5, '2024-07-08 04:05:00', 44.14, 36.49, 17, NULL, 1),
(6, '2024-07-08 04:39:18', 43.62, 36.39, NULL, 7, 1),
(7, '2024-07-09 04:40:34', 84.94, 36.49, NULL, 16, 1),
(8, '2024-07-09 04:40:34', 13.92, 36.49, NULL, 15, 1),
(9, '2024-07-09 04:40:34', 41.88, 36.49, NULL, 2, 1),
(10, '2024-07-09 04:40:34', 74.24, 36.49, NULL, 9, 1),
(11, '2024-07-10 04:43:00', 13.34, 36.49, 22, NULL, 1),
(12, '2024-07-10 04:44:00', 13.05, 36.49, 2, NULL, 1),
(13, '2024-07-10 04:44:00', 33.64, 36.49, 13, NULL, 1),
(14, '2024-07-18 04:53:00', 24.36, 36.51, 1, NULL, 1),
(15, '2024-07-17 15:23:00', 13.91, 36.54, 5, NULL, 1),
(16, '2024-07-16 15:23:00', 9.86, 36.54, 10, NULL, 1),
(17, '2024-07-18 15:24:00', 5.51, 36.54, 1, NULL, 1);

--
-- Disparadores `transacciones`
--
DELIMITER $$
CREATE TRIGGER `check_admin_compra` BEFORE INSERT ON `transacciones` FOR EACH ROW BEGIN

    IF NEW.importe_en_dolares < 0 AND NEW.usuarios_id NOT IN (SELECT id FROM usuarios WHERE rol = 'administrador') THEN

        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Solo el administrador puede registrar una compra.';

    END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validar_clientes_proveedores` BEFORE INSERT ON `transacciones` FOR EACH ROW BEGIN

    IF (NEW.clientes_id IS NULL AND NEW.proveedores_id IS NULL) OR (NEW.clientes_id IS NOT NULL AND NEW.proveedores_id IS NOT NULL) THEN

        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: clientes_id y proveedores_id no pueden ser ambos NULL o ambos diferentes de NULL.';

    END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validar_monto` BEFORE INSERT ON `transacciones` FOR EACH ROW BEGIN

    IF (NEW.importe_en_dolares > 0 AND

    NEW.proveedores_id IS NOT NULL) THEN

        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El importe de una compra no puede ser positivo.';

    ELSEIF (NEW.importe_en_dolares < 0 AND NEW.clientes_id IS NOT NULL) THEN

            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El importe de una venta no puede ser negativo.';

    END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transacciones_tiene_productos`
--

CREATE TABLE `transacciones_tiene_productos` (
  `transacciones_id` int(11) NOT NULL,
  `productos_id` int(11) NOT NULL,
  `cantidad` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `transacciones_tiene_productos`
--

INSERT INTO `transacciones_tiene_productos` (`transacciones_id`, `productos_id`, `cantidad`) VALUES
(1, 1, 60),
(1, 2, 80),
(2, 22, 2),
(2, 19, 1),
(2, 18, 1),
(3, 2, 2),
(4, 1, 4),
(4, 4, 1),
(5, 7, 4),
(5, 6, 1),
(5, 14, 1),
(6, 20, 4),
(6, 2, 4),
(7, 8, 2),
(7, 7, 7),
(7, 4, 1),
(7, 3, 1),
(8, 2, 4),
(9, 5, 2),
(9, 6, 4),
(9, 14, 2),
(10, 10, 10),
(10, 12, 2),
(11, 7, 1),
(11, 6, 1),
(12, 5, 1),
(12, 4, 1),
(13, 7, 4),
(14, 2, 7),
(15, 2, 2),
(15, 3, 1),
(16, 6, 2),
(17, 5, 1);

--
-- Disparadores `transacciones_tiene_productos`
--
DELIMITER $$
CREATE TRIGGER `actualizar_stock_monto` AFTER INSERT ON `transacciones_tiene_productos` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `cedula` varchar(12) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `rol` enum('empleado','administrador') NOT NULL,
  `hash_de_contrasena` varchar(60) NOT NULL,
  `pregunta_seguridad` enum('¿Cuándo es tu cumpleaños?','¿A qué secundaria fuiste?','¿Cómo se llamaba tu mamá?','¿Cuál es tu postre favorito?') NOT NULL,
  `respuesta_seguridad` varchar(60) NOT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `cedula`, `nombre`, `rol`, `hash_de_contrasena`, `pregunta_seguridad`, `respuesta_seguridad`, `status`) VALUES
(1, '30597012', 'Ana Mota', 'administrador', '$2b$12$L83bWlRfyz9/KODyRWF1d.uksvrr4O9mX9q0p2Q7RT3xVVNHn55RS', '¿Cuál es tu postre favorito?', '$2y$10$wdKk9e/y5sSN2tTwMQ0ux.q9cwkhsfwTo4nO1Zt4dK9Dmv0Qn/.1S', 1),
(2, '29877987', 'Samuel Rincon', 'empleado', '$2b$12$v0/S73aOSgMLNMqY1joW6uIT2RtBO/NrfHEM9rd/zn4a9IpIAg2oS', '¿Cuál es tu postre favorito?', '$2b$12$rOpp6x4G2vQUFdrrtwO.DOabA4YrGjeUMoTqkAoordE70JBNqG1NG', 1),
(3, '31575257', 'Juan Urdaneta', 'empleado', '$2b$12$/c1gm3lEVMZp1bypsdLyK.5oDXgsXGcZQ2SAL2K6wHxzE17N/m.bu', '¿Cuál es tu postre favorito?', '$2b$12$eQpp7thlc.If7LruajoyJO9i8v8tn2jTomQLw7yw7/gJ/lCUz0uym', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD UNIQUE KEY `cedula_UNIQUE` (`cedula`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idproveedores_UNIQUE` (`id`),
  ADD UNIQUE KEY `rif_UNIQUE` (`rif`);

--
-- Indices de la tabla `transacciones`
--
ALTER TABLE `transacciones`
  ADD PRIMARY KEY (`id`,`usuarios_id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_transacciones_clientes1_idx` (`clientes_id`),
  ADD KEY `fk_transacciones_proveedores1_idx` (`proveedores_id`),
  ADD KEY `fk_transacciones_usuarios1_idx` (`usuarios_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idusuarios_UNIQUE` (`id`),
  ADD UNIQUE KEY `cedula_UNIQUE` (`cedula`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `transacciones`
--
ALTER TABLE `transacciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `transacciones`
--
ALTER TABLE `transacciones`
  ADD CONSTRAINT `fk_transacciones_clientes1` FOREIGN KEY (`clientes_id`) REFERENCES `clientes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_transacciones_proveedores1` FOREIGN KEY (`proveedores_id`) REFERENCES `proveedores` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_transacciones_usuarios1` FOREIGN KEY (`usuarios_id`) REFERENCES `usuarios` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
