-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-06-2024 a las 10:09:20
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
(1, 'Antonio Villalobos', 'Maracaibo', '04145555556', '30643276', 1),
(2, 'Samuel Rincon', 'Los Olivos', '04125555555', '29888888', 1),
(3, 'Juan Urdaneta', 'C2', '04146074412', '29999999', 0);

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
(1, 'Vainilla', '2024-12-31', 82, NULL, 3.99, 1),
(2, 'Chocolate', '2024-12-31', 91, NULL, 4.99, 1),
(3, 'Sorbete de Limón', '2024-12-31', 72, NULL, 3.49, 1),
(4, 'Fresa', '2024-12-31', 104, NULL, 4.50, 1),
(5, 'Menta', '2024-12-31', 60, NULL, 4.49, 0);

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
(1, 'HELADOS TIO RICO', 'J88888888', 'CARACAS', 1),
(2, 'HELADOS LA ARGENTINA', 'J99999999', '5 DE JULIO XD', 1),
(3, 'HELADOS CARABOBO', 'J-40855439-9', 'Carabobo', 1);

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
(1, '2024-06-11 18:07:29', 24.95, 38.00, NULL, 1, 1),
(2, '2024-06-12 03:59:48', 134.70, 38.00, NULL, 1, 1),
(3, '2024-06-13 14:52:34', 345.00, 38.00, 1, NULL, 1),
(4, '2024-06-11 14:53:03', 213.00, 38.00, 2, NULL, 1),
(5, '2024-06-13 14:53:49', 46.00, 38.00, 3, NULL, 1),
(6, '2024-06-13 14:56:33', 24.95, 38.00, 1, NULL, 2),
(7, '2024-06-30 14:41:00', 24.95, 38.00, 3, NULL, 1),
(8, '2024-06-30 14:42:00', 9.98, 38.00, 1, NULL, 1),
(9, '2024-06-20 14:46:00', 15.96, 37.00, 2, NULL, 5),
(10, '2024-06-18 14:50:00', 23.94, 37.00, 2, NULL, 1),
(11, '2024-06-18 15:21:00', 7.98, 50.00, 1, NULL, 1),
(12, '2024-06-14 15:21:00', 4.99, 23.00, 2, NULL, 1),
(13, '2024-06-09 15:39:00', 17.45, 45.00, 1, NULL, 1),
(14, '2024-06-18 17:00:00', 39.92, 36.42, 1, NULL, 1),
(17, '2024-06-19 07:52:19', 25.44, 38.00, 3, NULL, 1),
(18, '2024-06-19 08:03:00', 12.49, 36.42, 3, NULL, 1),
(19, '2024-06-19 08:06:00', 25.96, 36.42, 2, NULL, 1);

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
(1, 2, 5),
(2, 5, 30),
(6, 2, 5),
(7, 2, 5),
(8, 2, 2),
(9, 1, 4),
(10, 1, 6),
(11, 1, 2),
(12, 2, 1),
(13, 3, 5),
(14, 2, 8),
(16, 4, 2),
(16, 3, 1),
(17, 1, 3),
(17, 2, 2),
(17, 3, 1),
(18, 4, 2),
(18, 3, 1),
(19, 4, 2),
(19, 2, 1),
(19, 1, 3);

--
-- Disparadores `transacciones_tiene_productos`
--
DELIMITER $$
CREATE TRIGGER `actualizar_stock_monto` AFTER INSERT ON `transacciones_tiene_productos` FOR EACH ROW BEGIN

    DECLARE total_amount DECIMAL(10, 2);

    

    

    UPDATE productos 

    SET cantidad_disponible = cantidad_disponible - NEW.cantidad 

    WHERE id = NEW.productos_id;

    

    

    SET total_amount = (SELECT SUM(cantidad * precio_en_dolares) FROM transacciones_tiene_productos 

                        JOIN productos ON transacciones_tiene_productos.productos_id = productos.id

                        WHERE transacciones_tiene_productos.transacciones_id = NEW.transacciones_id);

    

    

    UPDATE transacciones

    SET importe_en_dolares = total_amount

    WHERE id = NEW.transacciones_id;

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
  `respuesta_seguridad` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `cedula`, `nombre`, `rol`, `hash_de_contrasena`, `pregunta_seguridad`, `respuesta_seguridad`) VALUES
(1, '30597012', 'Ana Mota', 'administrador', '$2b$12$TB07LX0M/Ipz7ikFDt/OJeHmZ.ePzPS6wz.7KGnQC.aHAkEtohM0C', '¿Cuál es tu postre favorito?', '$2y$10$wdKk9e/y5sSN2tTwMQ0ux.q9cwkhsfwTo4nO1Zt4dK9Dmv0Qn/.1S'),
(2, '29877987', 'Samuel Rincon', 'empleado', '$2y$10$IsiNfgnLdHIvvf2GlVzegOBINWykVFtxiklJrt/2m7aeZgJ6PYsVS', '¿Cuál es tu postre favorito?', '$2y$10$KUcsOLOw6C8MzL5oNoOcwuJCbGuTiLQN9Dr7ykcqTRGh2oqiFN15e'),
(5, '123123123', 'Jesus', 'empleado', '$2b$12$Y6lba6FwpfibCzmV78z3Fups6wNYcLtCXUrjAGRrQRM90M6QrPDd.', '¿Cómo se llamaba tu mamá?', '$2b$12$Cd4M4i7mkDY5QSc64o5Wq.s.Mz2QW.ZX0svYCrjVFokL93sTnUrDG');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `transacciones`
--
ALTER TABLE `transacciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
