-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-06-2026 a las 22:25:08
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `solar_web`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apertura_caja`
--

CREATE TABLE `apertura_caja` (
  `id` int(11) NOT NULL,
  `caja_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_apertura` datetime NOT NULL,
  `monto_inicial` decimal(10,2) DEFAULT 0.00,
  `estado` enum('abierta','cerrada','anulada') DEFAULT 'abierta',
  `observaciones_apertura` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `apertura_caja`
--

INSERT INTO `apertura_caja` (`id`, `caja_id`, `usuario_id`, `fecha_apertura`, `monto_inicial`, `estado`, `observaciones_apertura`, `created_at`) VALUES
(1, 1, 1, '2026-05-19 16:18:25', 100.00, 'cerrada', 'prueba', '2026-05-19 16:18:25'),
(2, 1, 3, '2026-05-19 17:28:29', 300.00, 'cerrada', 'caja de prueba\r\n', '2026-05-19 17:28:29'),
(3, 1, 3, '2026-05-19 17:41:25', 600.00, 'cerrada', 'caja de prueba para mostrar a gerencia', '2026-05-19 17:41:25'),
(4, 1, 1, '2026-05-19 18:08:38', 300.00, 'cerrada', 'prueba', '2026-05-19 18:08:38'),
(5, 7, 2, '2026-05-20 12:12:09', 500.00, 'cerrada', '100 de 1 peso\r\n100 de 2 pesos\r\n50 de 5 pesos', '2026-05-20 12:12:09'),
(6, 7, 2, '2026-05-21 10:06:45', 500.00, 'cerrada', '500 monedas de 1 bs', '2026-05-21 10:06:45'),
(7, 7, 2, '2026-05-25 17:52:34', 100.00, 'cerrada', '', '2026-05-25 17:52:34'),
(8, 1, 2, '2026-05-25 22:11:15', 100.00, 'cerrada', '100 monedas de 1 boliviano para caja chica\r\n', '2026-05-25 22:11:15'),
(9, 7, 2, '2026-05-25 22:24:24', 200.00, 'cerrada', '', '2026-05-25 22:24:24'),
(10, 1, 2, '2026-05-25 23:53:53', 1000.00, 'cerrada', 'monedas de 1, 2 y  5 bs', '2026-05-25 23:53:53'),
(11, 1, 2, '2026-05-26 12:02:01', 1000.00, 'cerrada', '1000 monedas de 1 bs', '2026-05-26 12:02:01'),
(12, 7, 3, '2026-05-26 17:07:08', 100.00, 'cerrada', '', '2026-05-26 17:07:08'),
(13, 7, 3, '2026-05-27 10:31:49', 100.00, 'cerrada', '', '2026-05-27 10:31:49');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cajas`
--

CREATE TABLE `cajas` (
  `id` int(11) NOT NULL,
  `sucursal_id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `estado` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cajas`
--

INSERT INTO `cajas` (`id`, `sucursal_id`, `nombre`, `estado`) VALUES
(1, 2, 'CAJA', 1),
(3, 2, 'Csjs 2', 0),
(4, 4, 'Caja 1', 0),
(5, 4, 'caja 3', 0),
(6, 2, 'Caja 20', 0),
(7, 1, 'caja concierto', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `icono` varchar(100) DEFAULT NULL,
  `estado` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `icono`, `estado`) VALUES
(1, 'Combos', 'fas-fa-chicken', 1),
(2, 'Platos', 'fas-fa-burguer', 1),
(3, 'Porciones', 'fas-fa-chicken', 1),
(4, 'Bebidas', 'fas-fa-chicken', 1),
(5, 'Categoria nueva', '', 0),
(6, 'Nueva categoria', '', 0),
(7, 'otar categoria', '', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cierre_caja`
--

CREATE TABLE `cierre_caja` (
  `id` int(11) NOT NULL,
  `apertura_caja_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha_cierre` datetime NOT NULL,
  `monto_esperado` decimal(10,2) NOT NULL,
  `monto_real` decimal(10,2) NOT NULL,
  `diferencia` decimal(10,2) GENERATED ALWAYS AS (`monto_real` - `monto_esperado`) STORED,
  `observaciones_cierre` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cierre_caja`
--

INSERT INTO `cierre_caja` (`id`, `apertura_caja_id`, `usuario_id`, `fecha_cierre`, `monto_esperado`, `monto_real`, `observaciones_cierre`, `created_at`) VALUES
(1, 1, 1, '2026-05-19 17:27:16', 138.00, 138.00, 'esta caja es de prueba', '2026-05-19 17:27:16'),
(2, 2, 3, '2026-05-19 17:29:29', 376.00, 370.00, 'cierre de segunda caja', '2026-05-19 17:29:29'),
(3, 3, 3, '2026-05-19 17:53:59', 790.00, 630.00, 'cierre de caja barriolindo', '2026-05-19 17:53:59'),
(4, 5, 2, '2026-05-21 09:30:08', 618.02, 540.00, 'monto total de dinero en caja', '2026-05-21 09:30:08'),
(5, 4, 1, '2026-05-25 17:46:03', 494.02, 200.00, '', '2026-05-25 17:46:03'),
(6, 6, 2, '2026-05-25 17:48:06', 694.00, 500.00, '', '2026-05-25 17:48:06'),
(7, 7, 2, '2026-05-25 22:05:28', 138.00, 300.00, '', '2026-05-25 22:05:28'),
(8, 8, 2, '2026-05-25 22:11:48', 176.00, 100.00, '', '2026-05-25 22:11:48'),
(9, 9, 2, '2026-05-25 22:38:51', 436.00, 500.00, '', '2026-05-25 22:38:51'),
(10, 10, 2, '2026-05-25 23:55:21', 1118.00, 1300.00, 'se vendio tanto', '2026-05-25 23:55:21'),
(11, 12, 3, '2026-05-26 17:08:04', 138.00, 138.00, '', '2026-05-26 17:08:04'),
(12, 11, 2, '2026-05-26 17:08:41', 1076.00, 1000.00, '', '2026-05-26 17:08:41'),
(13, 13, 3, '2026-06-03 16:30:06', 442.00, 100.00, '50Qr\r\n50efectivo', '2026-06-03 16:30:06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `documento` varchar(50) DEFAULT NULL,
  `tipo_documento` varchar(50) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `estado` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `nombre`, `email`, `telefono`, `documento`, `tipo_documento`, `direccion`, `created_at`, `estado`) VALUES
(1, 'Sin Nombre', 'sn@gmail.com', '666', '', 'CI', '', '2026-05-19 11:44:13', 1),
(2, 'Lizeth srl', 'lizeth@polloelsolar.com', '7546856`', '302876028', 'NIT', '', '2026-06-02 10:37:54', 1),
(3, 'miguel aguilar', '', '77323800', '', 'CI', '', '2026-06-03 16:24:05', 1),
(4, 'Francisco Rojas', '', '77982764', '', 'CI', '', '2026-06-03 16:26:56', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `logs_actividad`
--

CREATE TABLE `logs_actividad` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `accion` varchar(100) DEFAULT NULL,
  `detalle` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `logs_actividad`
--

INSERT INTO `logs_actividad` (`id`, `usuario_id`, `accion`, `detalle`, `ip_address`, `created_at`) VALUES
(1, 1, 'INSERTAR_CATEGORIA', 'Se creó la categoría: Guarniciones', '::1', '2026-03-26 10:56:39'),
(2, 1, 'EDITAR_CATEGORIA', 'Se actualizaron los datos de: Porciones (ID: 3)', '::1', '2026-03-26 10:57:48'),
(3, 1, 'EDITAR_USUARIO', 'Se actualizaron los datos de: javi (ID: 1)', '::1', '2026-03-26 10:58:20'),
(4, 1, 'EDITAR_SUCURSAL', 'Se actualizaron los datos de: Sucursal Cañoto (ID: 1)', '::1', '2026-03-26 10:59:31'),
(5, 1, 'INSERTAR_USUARIO', 'Se creó al usuario: ernesto', '::1', '2026-03-26 11:04:35'),
(6, 1, 'INSERTAR_CATEGORIA', 'Se creó la categoría: Bebidas ', '::1', '2026-03-26 11:09:58'),
(7, 1, 'EDITAR_CATEGORIA', 'Se actualizaron los datos de: Guarniciones (ID: 3)', '::1', '2026-03-26 11:16:38'),
(8, 1, 'EDITAR_CATEGORIA', 'Se actualizaron los datos de: Porciones (ID: 3)', '::1', '2026-03-26 11:16:47'),
(9, 1, 'INSERTAR_CATEGORIA', 'Se creó la categoría: Categoria nueva', '::1', '2026-03-26 11:16:56'),
(10, 1, 'ELIMINAR_CATEGORIA', 'Se eliminó la categoría: Categoria nueva (ID: 5)', '::1', '2026-03-26 11:17:06'),
(11, 1, 'INSERTAR_CATEGORIA', 'Se creó la categoría: Nueva categoria', '::1', '2026-03-26 11:19:53'),
(12, 1, 'INSERTAR_CATEGORIA', 'Se creó la categoría: otar categoria', '::1', '2026-03-26 11:20:09'),
(13, 1, 'ELIMINAR_CATEGORIA', 'ID eliminado: 6', '::1', '2026-03-26 11:20:15'),
(14, 1, 'ELIMINAR_CATEGORIA', 'ID eliminado: 7', '::1', '2026-03-26 11:20:18'),
(15, 1, 'EDITAR_CATEGORIA', 'Se actualizaron los datos de: Bebidaa (ID: 4)', '::1', '2026-03-26 11:20:30'),
(16, 1, 'EDITAR_CATEGORIA', 'Se actualizaron los datos de: Bebidas (ID: 4)', '::1', '2026-03-26 11:20:36'),
(17, 1, 'INSERTAR_USUARIO', 'Se creó al usuario: andres', '::1', '2026-03-26 11:24:09'),
(18, 1, 'EDITAR_USUARIO', 'Se actualizaron los datos de: andress (ID: 3)', '::1', '2026-03-26 11:24:28'),
(19, 1, 'INSERTAR_PRODUCTO', 'Producto creado: Cuarto pecho', '::1', '2026-03-26 12:06:43'),
(20, 1, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 1 establecido en visible=0', '::1', '2026-03-26 12:17:31'),
(21, 1, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 1 establecido en visible=1', '::1', '2026-03-26 12:17:32'),
(22, 1, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 1 establecido en visible=0', '::1', '2026-03-26 12:17:34'),
(23, 1, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 1 establecido en visible=1', '::1', '2026-03-26 12:17:40'),
(24, 1, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 1 establecido en visible=0', '::1', '2026-03-26 12:17:44'),
(25, 1, 'EDITAR_PRODUCTO', 'Actualizado: Cuarto pecho (ID: 1)', '::1', '2026-03-26 12:18:15'),
(26, 1, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 1 establecido en visible=1', '::1', '2026-03-26 12:18:21'),
(27, 1, 'EDITAR_PRODUCTO', 'Actualizado: Cuarto pecho (ID: 1)', '::1', '2026-03-27 10:03:31'),
(28, 1, 'EDITAR_PRODUCTO', 'Actualizado: Cuarto pecho (ID: 1)', '::1', '2026-03-27 10:11:24'),
(29, 1, 'ACTUALIZAR_POPUP', 'Popup actualizado: Combo lunes ', '::1', '2026-03-27 11:49:45'),
(30, 1, 'ACTUALIZAR_POPUP', 'Popup actualizado: Combo lunes ', '::1', '2026-03-27 11:51:04'),
(31, 2, 'EDITAR_CATEGORIA', 'Se actualizaron los datos de: Bebidass (ID: 4)', '::1', '2026-03-30 10:21:13'),
(32, 2, 'EDITAR_CATEGORIA', 'Se actualizaron los datos de: Bebidas (ID: 4)', '::1', '2026-03-30 10:21:27'),
(33, 2, 'EDITAR_SUCURSAL', 'Se actualizaron los datos de: Sucursal Cañoto (ID: 1)', '::1', '2026-03-30 10:41:20'),
(34, 2, 'INSERTAR_SUCURSAL', 'Se creó la sucursal: FERIA BARRIO LINDO', '::1', '2026-03-30 11:57:55'),
(35, 2, 'EDITAR_USUARIO', 'Se actualizaron los datos de: andres (ID: 3)', '::1', '2026-03-30 12:13:09'),
(36, 3, 'EDITAR_SUCURSAL', 'Se actualizaron los datos de: FERIA BARRIO LINDO (ID: 2)', '::1', '2026-04-01 10:23:11'),
(37, 1, 'INSERTAR_SUCURSAL', 'Se creó la sucursal: Sucursal Km6 ', '::1', '2026-04-02 11:28:48'),
(38, 1, 'INSERTAR_SUCURSAL', 'Se creó la sucursal: Sucursal Autopia ', '::1', '2026-04-02 11:36:01'),
(39, 3, 'INSERTAR_POPUP', 'Popup creado: Combo lunes', '::1', '2026-04-14 17:33:31'),
(40, 3, 'ACTUALIZAR_POPUP', 'Popup actualizado: Combo lunes ', '::1', '2026-04-14 17:33:50'),
(41, 1, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 1 establecido en visible=0', '::1', '2026-04-30 16:33:33'),
(42, 1, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 1 establecido en visible=1', '::1', '2026-04-30 16:33:33'),
(43, 1, 'INSERTAR_METODO_PAGO', 'Se creó el método de pago: Efectivo', '::1', '2026-05-19 11:36:33'),
(44, 1, 'INSERTAR_METODO_PAGO', 'Se creó el método de pago: QR', '::1', '2026-05-19 11:36:50'),
(45, 1, 'INSERTAR_METODO_PAGO', 'Se creó el método de pago: Transferencia', '::1', '2026-05-19 11:38:15'),
(46, 1, 'ELIMINAR_METODO_PAGO', 'ID eliminado: 3', '::1', '2026-05-19 11:38:23'),
(47, 1, 'INSERTAR_METODO_PAGO', 'Se creó el método de pago: Efectivo', '::1', '2026-05-19 11:41:19'),
(48, 1, 'EDITAR_METODO_PAGO', 'Se actualizó el método de pago: Efectivos (ID: 4)', '::1', '2026-05-19 11:42:01'),
(49, 1, 'INSERTAR_METODO_PAGO', 'Se creó el método de pago: Efectivo', '::1', '2026-05-19 11:42:33'),
(50, 1, 'INSERTAR_METODO_PAGO', 'Se creó el método de pago: QR', '::1', '2026-05-19 11:42:44'),
(51, 1, 'INSERTAR_CLIENTE', 'Se creó el cliente: Sin Nombre', '::1', '2026-05-19 11:44:13'),
(52, 1, 'EDITAR_CLIENTE', 'Se actualizó el cliente: Sin Nombres (ID: 1)', '::1', '2026-05-19 11:44:29'),
(53, 1, 'EDITAR_CLIENTE', 'Se actualizó el cliente: Sin Nombre (ID: 1)', '::1', '2026-05-19 11:44:35'),
(54, 1, 'INSERTAR_CAJA', 'Se creó la caja: caja en sucursal ID: 2', '::1', '2026-05-19 11:46:13'),
(55, 1, 'EDITAR_CAJA', 'Se actualizó la caja: CAJA (ID: 1)', '::1', '2026-05-19 11:46:35'),
(56, 1, 'INSERTAR_CAJA', 'Se creó la caja: Caja ambulante en sucursal ID: 2', '::1', '2026-05-19 11:46:55'),
(57, 1, 'ELIMINAR_CAJA', 'ID eliminado: 2', '::1', '2026-05-19 11:47:06'),
(58, 1, 'INSERTAR_METODO_PAGO', 'Se creó el método de pago: Transferencia', '::1', '2026-05-19 11:53:57'),
(59, 1, 'EDITAR_CAJA', 'Se actualizó la caja: CAJA1 (ID: 1)', '::1', '2026-05-19 11:56:15'),
(60, 1, 'INSERTAR_CAJA', 'Se creó la caja: Csjs 2', '::1', '2026-05-19 11:56:24'),
(61, 1, 'DESACTIVAR_CAJA', 'Se desactivó la caja ID: 3', '::1', '2026-05-19 11:56:31'),
(62, 1, 'INSERTAR_CAJA', 'Se creó la caja: Caja 1', '::1', '2026-05-19 11:58:10'),
(63, 1, 'DESACTIVAR_CAJA', 'Se desactivó la caja ID: 4', '::1', '2026-05-19 11:58:15'),
(64, 1, 'INSERTAR_CAJA', 'Se creó la caja: caja 3 en sucursal ID: 4', '::1', '2026-05-19 12:01:34'),
(65, 1, 'DESACTIVAR_CAJA', 'Se desactivó la caja ID: 5', '::1', '2026-05-19 12:01:49'),
(66, 1, 'INSERTAR_CAJA', 'Se creó la caja: Caja 20', '::1', '2026-05-19 12:07:11'),
(67, 1, 'DESACTIVAR_CAJA', 'Se desactivó la caja ID: 6', '::1', '2026-05-19 12:07:32'),
(68, 1, 'EDITAR_CAJA', 'Se actualizó la caja: CAJA (ID: 1)', '::1', '2026-05-19 12:09:20'),
(69, 1, 'ELIMINAR_METODO_PAGO', 'Método de pago eliminado ID: 7', '::1', '2026-05-19 15:22:09'),
(70, 1, 'INSERTAR_METODO_PAGO', 'Se creó el método de pago: Transferencia', '::1', '2026-05-19 15:22:17'),
(71, 1, 'APERTURA_CAJA', 'Se abrió caja ID: 1 con monto inicial: 100', '::1', '2026-05-19 16:18:25'),
(72, 1, 'VENTA_REGISTRADA', 'Venta ID: 1 - Total: 38 BOB', '::1', '2026-05-19 17:24:31'),
(73, 1, 'CIERRE_CAJA', 'Cierre de caja ID: 1 - Esperado: 138 - Real: 138', '::1', '2026-05-19 17:27:16'),
(74, 3, 'APERTURA_CAJA', 'Se abrió caja ID: 1 con monto inicial: 300', '::1', '2026-05-19 17:28:29'),
(75, 3, 'VENTA_REGISTRADA', 'Venta ID: 2 - Total: 76 BOB', '::1', '2026-05-19 17:28:57'),
(76, 3, 'CIERRE_CAJA', 'Cierre de caja ID: 2 - Esperado: 376 - Real: 370', '::1', '2026-05-19 17:29:29'),
(77, 1, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 1 establecido en visible=0', '::1', '2026-05-19 17:38:03'),
(78, 1, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 1 establecido en visible=1', '::1', '2026-05-19 17:38:06'),
(79, 3, 'INSERTAR_CAJA', 'Se creó la caja: caja concierto', '::1', '2026-05-19 17:40:54'),
(80, 3, 'APERTURA_CAJA', 'Se abrió caja ID: 1 con monto inicial: 600', '::1', '2026-05-19 17:41:25'),
(81, 3, 'VENTA_REGISTRADA', 'Venta ID: 3 - Total: 190 BOB', '::1', '2026-05-19 17:43:56'),
(82, 3, 'CIERRE_CAJA', 'Cierre de caja ID: 3 - Esperado: 790 - Real: 630', '::1', '2026-05-19 17:53:59'),
(83, 1, 'INSERTAR_METODO_PAGO', 'Se creó el método de pago: Cupon', '::1', '2026-05-19 17:59:22'),
(84, 1, 'ELIMINAR_METODO_PAGO', 'Método de pago eliminado ID: 9', '::1', '2026-05-19 17:59:27'),
(85, 1, 'INSERTAR_PRODUCTO', 'Producto creado: combo familiar', '::1', '2026-05-19 18:03:45'),
(86, 1, 'APERTURA_CAJA', 'Se abrió caja ID: 1 con monto inicial: 300', '::1', '2026-05-19 18:08:38'),
(87, 1, 'EDITAR_PRODUCTO', 'Actualizado: combo familiar (ID: 2)', '::1', '2026-05-19 18:08:59'),
(88, 1, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 2 establecido en visible=1', '::1', '2026-05-19 18:09:04'),
(89, 1, 'VENTA_REGISTRADA', 'Venta ID: 4 - Total: 80.016 BOB', '::1', '2026-05-19 18:13:27'),
(90, 3, 'EDITAR_USUARIO', 'Se actualizaron los datos de: ernesto (ID: 2)', '::1', '2026-05-19 20:22:52'),
(91, 2, 'APERTURA_CAJA', 'Vendedor abrió caja ID: 7 con monto: 500', '::1', '2026-05-20 12:12:09'),
(92, 2, 'VENTA_REGISTRADA', 'Venta ID: 5 - Total: 118.0236 BOB', '::1', '2026-05-20 12:12:37'),
(93, 1, 'VENTA_REGISTRADA', 'Venta ID: 6 - Total: 76 BOB', '::1', '2026-05-20 17:09:49'),
(94, 2, 'CIERRE_CAJA', 'Cierre de caja ID: 5 - Esperado: 618.02 - Real: 540', '::1', '2026-05-21 09:30:08'),
(95, 2, 'APERTURA_CAJA', 'Vendedor abrió caja ID: 7 con monto: 500', '::1', '2026-05-21 10:06:45'),
(96, 2, 'VENTA_REGISTRADA', 'Venta ID: 7 - Total: 194 BOB', '::1', '2026-05-21 10:07:58'),
(97, 1, 'VENTA_REGISTRADA', 'Venta ID: 8 - Total: 38 BOB', '::1', '2026-05-25 14:16:55'),
(98, 1, 'CIERRE_CAJA', 'Cierre de caja ID: 4 - Esperado: 494.02 - Real: 200', '::1', '2026-05-25 17:46:03'),
(99, 2, 'CIERRE_CAJA', 'Cierre de caja ID: 6 - Esperado: 694 - Real: 500', '::1', '2026-05-25 17:48:06'),
(100, 2, 'APERTURA_CAJA', 'Vendedor abrió caja ID: 7 con monto: 100', '::1', '2026-05-25 17:52:34'),
(101, 2, 'VENTA_REGISTRADA', 'Venta ID: 9 - Total: 38 BOB', '::1', '2026-05-25 17:52:42'),
(102, 2, 'CIERRE_CAJA', 'Cierre de caja ID: 7 - Esperado: 138 - Real: 300', '::1', '2026-05-25 22:05:28'),
(103, 2, 'APERTURA_CAJA', 'Vendedor abrió caja ID: 1 con monto: 100', '::1', '2026-05-25 22:11:15'),
(104, 2, 'VENTA_REGISTRADA', 'Venta ID: 10 - Total: 76 BOB', '::1', '2026-05-25 22:11:21'),
(105, 2, 'CIERRE_CAJA', 'Cierre de caja ID: 8 - Esperado: 176 - Real: 100', '::1', '2026-05-25 22:11:48'),
(106, 2, 'APERTURA_CAJA', 'Vendedor abrió caja ID: 7 con monto: 200', '::1', '2026-05-25 22:24:24'),
(107, 2, 'VENTA_REGISTRADA', 'Venta ID: 11 - Total: 80 BOB', '::1', '2026-05-25 22:24:32'),
(108, 2, 'VENTA_REGISTRADA', 'Venta ID: 12 - Total: 76 BOB', '::1', '2026-05-25 22:34:21'),
(109, 2, 'VENTA_REGISTRADA', 'Venta ID: 13 - Total: 80 BOB', '::1', '2026-05-25 22:37:04'),
(110, 2, 'CIERRE_CAJA', 'Cierre de caja ID: 9 - Esperado: 436 - Real: 500', '::1', '2026-05-25 22:38:51'),
(111, 2, 'APERTURA_CAJA', 'Vendedor abrió caja ID: 1 con monto: 1000', '::1', '2026-05-25 23:53:53'),
(112, 2, 'VENTA_REGISTRADA', 'Venta ID: 14 - Total: 118 BOB', '::1', '2026-05-25 23:54:30'),
(113, 2, 'CIERRE_CAJA', 'Cierre de caja ID: 10 - Esperado: 1118 - Real: 1300', '::1', '2026-05-25 23:55:21'),
(114, 2, 'APERTURA_CAJA', 'Vendedor abrió caja ID: 1 con monto: 1000', '::1', '2026-05-26 12:02:01'),
(115, 2, 'VENTA_REGISTRADA', 'Venta ID: 15 - Total: 76 BOB', '::1', '2026-05-26 12:03:26'),
(116, 3, 'APERTURA_CAJA', 'Vendedor abrió caja ID: 7 con monto: 100', '::1', '2026-05-26 17:07:08'),
(117, 3, 'VENTA_REGISTRADA', 'Venta ID: 16 - Total: 38 BOB', '::1', '2026-05-26 17:07:25'),
(118, 3, 'CIERRE_CAJA', 'Cierre de caja ID: 12 - Esperado: 138 - Real: 138', '::1', '2026-05-26 17:08:04'),
(119, 2, 'CIERRE_CAJA', 'Cierre de caja ID: 11 - Esperado: 1076 - Real: 1000', '::1', '2026-05-26 17:08:41'),
(120, 3, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 2 establecido en visible=0', '::1', '2026-05-27 10:31:30'),
(121, 3, 'VISIBILIDAD_PRODUCTO', 'Producto ID: 1 establecido en visible=0', '::1', '2026-05-27 10:31:30'),
(122, 3, 'APERTURA_CAJA', 'Vendedor abrió caja ID: 7 con monto: 100', '::1', '2026-05-27 10:31:49'),
(123, 3, 'ELIMINAR_PRODUCTO', 'ID: 2 (Seteado como no visible)', '::1', '2026-05-27 10:36:41'),
(124, 3, 'ELIMINAR_FOTO_PRODUCTO', 'Foto ID: 1 del Producto ID: 1', '::1', '2026-05-27 10:44:59'),
(125, 3, 'EDITAR_PRODUCTO', 'Actualizado: Cuarto pecho (ID: 1)', '::1', '2026-05-27 10:45:05'),
(126, 3, 'ELIMINAR_PRODUCTO', 'ID: 2 (Seteado como no visible)', '::1', '2026-05-27 10:45:12'),
(127, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 0', '::1', '2026-05-27 15:33:29'),
(128, 3, 'INSERTAR_SUCURSAL', 'Se creó la sucursal: Sucursal Isuto', '::1', '2026-05-27 15:36:05'),
(129, 3, 'TOGGLE_ESTADO_SUCURSAL', 'Sucursal ID: 5 - Estado POS: 0', '::1', '2026-05-27 15:36:48'),
(130, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 1', '::1', '2026-05-27 15:39:43'),
(131, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 3 - Visible Web: 0', '::1', '2026-05-27 15:46:19'),
(132, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 3 - Visible Web: 1', '::1', '2026-05-27 15:59:42'),
(133, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 3 - Visible Web: 0', '::1', '2026-05-27 15:59:44'),
(134, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 3 - Visible Web: 1', '::1', '2026-05-27 15:59:45'),
(135, 3, 'TOGGLE_ESTADO_SUCURSAL', 'Sucursal ID: 3 - Estado POS: 0', '::1', '2026-05-27 15:59:49'),
(136, 3, 'TOGGLE_ESTADO_SUCURSAL', 'Sucursal ID: 1 - Estado POS: 0', '::1', '2026-05-27 15:59:55'),
(137, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 0', '::1', '2026-05-27 16:01:11'),
(138, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 2 - Visible Web: 0', '::1', '2026-05-27 16:01:12'),
(139, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 1', '::1', '2026-05-27 16:01:38'),
(140, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 2 - Visible Web: 1', '::1', '2026-05-27 16:01:40'),
(141, 3, 'ELIMINAR_SUCURSAL', 'Se eliminó la sucursal ID: 5', '::1', '2026-05-27 16:03:55'),
(142, 3, 'EDITAR_SUCURSAL', 'Se actualizaron los datos de: Sucursal Isutos (ID: 5)', '::1', '2026-05-27 16:04:25'),
(143, 3, 'EDITAR_SUCURSAL', 'Se actualizaron los datos de: Sucursal Isutos (ID: 5)', '::1', '2026-05-27 16:04:34'),
(144, 3, 'EDITAR_SUCURSAL', 'Se actualizaron los datos de: Sucursal Isutos (ID: 5)', '::1', '2026-05-27 16:04:53'),
(145, 3, 'EDITAR_SUCURSAL', 'Se actualizaron los datos de: Sucursal Isutos (ID: 5)', '::1', '2026-05-27 16:04:57'),
(146, 3, 'INSERTAR_SUCURSAL', 'Se creó la sucursal: Sucursal Santos Dumont', '::1', '2026-05-27 16:05:28'),
(147, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 6 - Visible Web: 0', '::1', '2026-05-27 16:05:33'),
(148, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 0', '::1', '2026-05-27 16:05:35'),
(149, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 3 - Visible Web: 0', '::1', '2026-05-27 16:05:36'),
(150, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 2 - Visible Web: 0', '::1', '2026-05-27 16:05:37'),
(151, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 1 - Visible Web: 0', '::1', '2026-05-27 16:05:40'),
(152, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 5 - Visible Web: 1', '::1', '2026-05-28 15:09:27'),
(153, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 5 - Visible Web: 0', '::1', '2026-05-28 15:09:28'),
(154, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 5 - Visible Web: 1', '::1', '2026-05-28 15:09:28'),
(155, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 5 - Visible Web: 0', '::1', '2026-05-28 15:09:29'),
(156, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 6 - Visible Web: 1', '::1', '2026-05-28 15:17:35'),
(157, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 5 - Visible Web: 1', '::1', '2026-05-28 15:17:36'),
(158, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 1', '::1', '2026-05-28 15:17:36'),
(159, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 3 - Visible Web: 1', '::1', '2026-05-28 15:17:38'),
(160, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 3 - Visible Web: 0', '::1', '2026-05-28 15:17:39'),
(161, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 0', '::1', '2026-05-28 15:17:39'),
(162, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 5 - Visible Web: 0', '::1', '2026-05-28 15:17:40'),
(163, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 6 - Visible Web: 0', '::1', '2026-05-28 15:17:40'),
(164, 3, 'ELIMINAR_SUCURSAL', 'Se eliminó la sucursal ID: 5', '::1', '2026-05-28 15:17:50'),
(165, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 1', '::1', '2026-05-28 15:51:39'),
(166, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 3 - Visible Web: 1', '::1', '2026-05-28 15:51:41'),
(167, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 2 - Visible Web: 1', '::1', '2026-05-28 15:51:43'),
(168, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 1 - Visible Web: 1', '::1', '2026-05-28 15:51:43'),
(169, 3, 'ELIMINAR_SUCURSAL', 'Se eliminó la sucursal ID: 3', '::1', '2026-05-28 15:51:51'),
(170, 3, 'INSERTAR_SUCURSAL', 'Se creó la sucursal: Sucursal cambodromo', '::1', '2026-05-28 15:52:30'),
(171, 3, 'EDITAR_SUCURSAL', 'Se actualizaron los datos de: Sucursal cambodromo (ID: 7)', '::1', '2026-05-28 15:52:35'),
(172, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 7 - Visible Web: 0', '::1', '2026-05-28 15:53:44'),
(173, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 7 - Visible Web: 1', '::1', '2026-05-28 15:53:45'),
(174, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 0', '::1', '2026-05-28 15:53:45'),
(175, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 1', '::1', '2026-05-28 15:53:46'),
(176, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 0', '::1', '2026-05-28 15:53:47'),
(177, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 1', '::1', '2026-05-28 15:53:48'),
(178, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 7 - Visible Web: 0', '::1', '2026-05-28 15:55:17'),
(179, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 7 - Visible Web: 1', '::1', '2026-05-28 15:55:18'),
(180, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 7 - Visible Web: 0', '::1', '2026-05-28 15:55:18'),
(181, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 7 - Visible Web: 1', '::1', '2026-05-28 15:55:19'),
(182, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 0', '::1', '2026-05-28 15:55:30'),
(183, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 4 - Visible Web: 1', '::1', '2026-05-28 15:55:30'),
(184, 3, 'INSERTAR_SUCURSAL', 'Se creó la sucursal: Sucursal cambodromo', '::1', '2026-05-28 15:56:01'),
(185, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 8 - Visible Web: 0', '::1', '2026-05-28 15:56:04'),
(186, 3, 'TOGGLE_VISIBLE_SUCURSAL', 'Sucursal ID: 8 - Visible Web: 1', '::1', '2026-05-28 15:56:05'),
(187, 3, 'ELIMINAR_SUCURSAL', 'Se eliminó (Soft Delete) la sucursal ID: 7', '::1', '2026-05-28 15:56:08'),
(188, 3, 'EDITAR_SUCURSAL', 'Se actualizaron los datos de: Sucursal cambodromo (ID: 8)', '::1', '2026-05-28 15:56:16'),
(189, 3, 'INSERTAR_CLIENTE', 'Se creó el cliente: Lizeth srl', '::1', '2026-06-02 10:37:54'),
(190, 3, 'VENTA_REGISTRADA', 'Venta ID: 17 - Total: 114 BOB', '::1', '2026-06-02 10:38:33'),
(191, 3, 'INSERTAR_CLIENTE', 'Se creó el cliente: miguel aguilar', '::1', '2026-06-03 16:24:05'),
(192, 3, 'VENTA_REGISTRADA', 'Venta ID: 18 - Total: 38 BOB', '::1', '2026-06-03 16:25:09'),
(193, 3, 'INSERTAR_CLIENTE', 'Se creó el cliente: Francisco Rojas', '::1', '2026-06-03 16:26:56'),
(194, 3, 'VENTA_REGISTRADA', 'Venta ID: 19 - Total: 190 BOB', '::1', '2026-06-03 16:27:42'),
(195, 3, 'CIERRE_CAJA', 'Cierre de caja ID: 13 - Esperado: 442 - Real: 100', '::1', '2026-06-03 16:30:06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metodos_pago`
--

CREATE TABLE `metodos_pago` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `estado` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `metodos_pago`
--

INSERT INTO `metodos_pago` (`id`, `nombre`, `estado`) VALUES
(1, 'Efectivo', 0),
(2, 'QR', 0),
(3, 'Transferencia', 0),
(4, 'Efectivos', 0),
(5, 'Efectivo', 1),
(6, 'QR', 1),
(7, 'Transferencia', 0),
(8, 'Transferencia', 1),
(9, 'Cupon', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `popups`
--

CREATE TABLE `popups` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `ruta_foto` varchar(255) NOT NULL,
  `url_destino` varchar(255) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `lunes` tinyint(1) DEFAULT 0,
  `martes` tinyint(1) DEFAULT 0,
  `miercoles` tinyint(1) DEFAULT 0,
  `jueves` tinyint(1) DEFAULT 0,
  `viernes` tinyint(1) DEFAULT 0,
  `sabado` tinyint(1) DEFAULT 0,
  `domingo` tinyint(1) DEFAULT 0,
  `hora_inicio` time DEFAULT '00:00:00',
  `hora_cierre` time DEFAULT '23:59:59',
  `visible` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `popups`
--

INSERT INTO `popups` (`id`, `nombre`, `ruta_foto`, `url_destino`, `descripcion`, `fecha_inicio`, `fecha_fin`, `lunes`, `martes`, `miercoles`, `jueves`, `viernes`, `sabado`, `domingo`, `hora_inicio`, `hora_cierre`, `visible`, `created_at`) VALUES
(1, 'Combo lunes ', 'uploads/popups/1774623992_popup_COMBO DÚO (DISPONIBLE LOS MIÉRCOLES) -  EL SOLAR.jpg.jpeg', '', NULL, '2026-03-19', '2026-03-28', 0, 0, 0, 0, 1, 0, 0, '00:00:00', '23:59:00', 0, '2026-03-27 15:06:32'),
(2, 'Combo lunes', 'uploads/popups/1776202411_popup_COMBO DÚO.png', '', NULL, '2026-04-20', '2026-04-20', 1, 0, 0, 0, 0, 0, 0, '00:00:00', '23:59:00', 1, '2026-04-14 21:33:31');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `categoria_id` int(11) DEFAULT NULL,
  `sucursal_id` int(11) DEFAULT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `precio_oferta` decimal(10,2) DEFAULT NULL,
  `etiqueta_oferta` varchar(50) DEFAULT NULL,
  `moneda` enum('BOB','USD','PYG','BRL') DEFAULT 'BOB',
  `es_combo` tinyint(1) DEFAULT 0,
  `dia_semana` enum('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo','Todos') DEFAULT 'Todos',
  `visible` tinyint(1) DEFAULT 1,
  `estado` tinyint(1) NOT NULL DEFAULT 1,
  `destacado` tinyint(1) DEFAULT 0,
  `fecha_publicacion` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `categoria_id`, `sucursal_id`, `nombre`, `descripcion`, `precio`, `precio_oferta`, `etiqueta_oferta`, `moneda`, `es_combo`, `dia_semana`, `visible`, `estado`, `destacado`, `fecha_publicacion`, `created_at`) VALUES
(1, 2, NULL, 'Cuarto pecho', '1 cuarto pecho con porcion de arroz, porcion de papas y porcion de plátano', 38.00, 28.00, '10% de descuento', 'BOB', 0, 'Todos', 0, 1, 1, NULL, '2026-03-26 12:06:43'),
(2, 1, NULL, 'combo familiar', 'El combo consta de 1/4 pierna - 1/8 ala - 1/8 contra', 80.00, NULL, '', 'BOB', 0, 'Todos', 0, 0, 0, NULL, '2026-05-19 18:03:45');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_fotos`
--

CREATE TABLE `producto_fotos` (
  `id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `ruta_foto` varchar(255) NOT NULL,
  `orden` int(11) DEFAULT 0,
  `estado` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto_fotos`
--

INSERT INTO `producto_fotos` (`id`, `producto_id`, `ruta_foto`, `orden`, `estado`) VALUES
(1, 1, 'uploads/productos/1774541203_principal_CUARTO PECHO 2025 CENITAL.png', 0, 0),
(2, 2, 'uploads/productos/1779228225_principal_MAKRO.jpg', 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursales`
--

CREATE TABLE `sucursales` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `pais` enum('Bolivia','Paraguay','Brasil') NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `latitud` decimal(10,8) DEFAULT NULL,
  `longitud` decimal(11,8) DEFAULT NULL,
  `hora_apertura` time DEFAULT NULL,
  `hora_cierre` time DEFAULT NULL,
  `estado` tinyint(1) DEFAULT 1,
  `visible` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sucursales`
--

INSERT INTO `sucursales` (`id`, `nombre`, `pais`, `direccion`, `latitud`, `longitud`, `hora_apertura`, `hora_cierre`, `estado`, `visible`) VALUES
(1, 'Sucursal Cañoto', 'Bolivia', 'Av. Cañoto Esq. Suarez de Figueroa', -17.78644037, -63.18810054, '11:00:00', '00:30:00', 1, 1),
(2, 'FERIA BARRIO LINDO', 'Bolivia', 'Feria barrio lindo ( todos los miercoles y sabados ) ', -17.79129021, -63.15435432, '11:00:00', '16:00:00', 1, 1),
(3, 'Sucursal Km6 ', 'Bolivia', 'Avenida Doble vía la guardia 6to anillo ', -17.82834495, -63.22674072, '11:00:00', '01:00:00', 0, 0),
(4, 'Sucursal Autopia ', 'Bolivia', 'Avenida 3er anillo interno y Avenida Beni ', -17.75998965, -63.17476342, '11:00:00', '00:00:00', 1, 1),
(5, 'Sucursal Isutos', 'Bolivia', 'Av. Canal Isuto', -17.75470936, -63.19001242, '11:00:00', '23:00:00', 0, 0),
(6, 'Sucursal Santos Dumont', 'Bolivia', 'Av Santos dumont', 0.00000000, 0.00000000, '00:00:00', '00:00:00', 0, 0),
(7, 'Sucursal cambodromo', 'Bolivia', 'av mutualista 6to anillo', 0.00000000, 0.00000000, '10:00:00', '23:00:00', 0, 1),
(8, 'Sucursal cambodromo', 'Bolivia', 'cambodromo 6to anillo hiper', NULL, NULL, '11:00:00', '23:00:00', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursal_fotos`
--

CREATE TABLE `sucursal_fotos` (
  `id` int(11) NOT NULL,
  `sucursal_id` int(11) NOT NULL,
  `ruta_foto` varchar(255) NOT NULL,
  `orden` int(11) DEFAULT 0,
  `estado` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sucursal_fotos`
--

INSERT INTO `sucursal_fotos` (`id`, `sucursal_id`, `ruta_foto`, `orden`, `estado`) VALUES
(1, 1, 'uploads/sucursales/1774536276_CAÑOTO.png', 0, 1),
(2, 2, 'uploads/sucursales/1775053391_barriolindo.jpeg', 0, 1),
(3, 3, 'uploads/sucursales/1775143728_KM6.png', 0, 1),
(4, 4, 'uploads/sucursales/1775144161_AUTOPIA.png', 0, 1),
(5, 5, 'uploads/sucursales/1779912293_MAKRO.jpg', 0, 1),
(6, 8, 'uploads/sucursales/1779998161_DON_BOSCO.jpg', 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(250) DEFAULT NULL,
  `usuario` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('admin','editor') DEFAULT 'admin',
  `estado` tinyint(1) DEFAULT 1,
  `ultimo_acceso` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `usuario`, `password`, `rol`, `estado`, `ultimo_acceso`, `created_at`) VALUES
(1, 'Javier Condorcet Arce', 'javi', '$2y$10$6RtyzmMpV8e6w6/FAzuosOlRlfKXxWcIGC/d6LIt0sxO0gtjGzSoO', 'admin', 1, '2026-06-15 09:21:20', '2026-03-26 09:37:05'),
(2, 'Ernesto Gonzalvez ', 'ernesto', '$2y$10$.4DjU5RnXLOg88LvL5kV4uDYoBnQC5gGWiZB1m8VfHMnjEiIfByCq', 'editor', 1, '2026-05-26 17:08:19', '2026-03-26 11:04:35'),
(3, 'Andres', 'andres', '$2y$10$VPqlZ7t2QcdmdXYcGC9ZLeMXQZJfi0c0ugRX8VZJdDXvZMDONBVM6', 'admin', 1, '2026-06-18 15:57:14', '2026-03-26 11:24:09');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id` int(11) NOT NULL,
  `sucursal_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `apertura_caja_id` int(11) NOT NULL,
  `fecha_venta` datetime DEFAULT NULL,
  `descuento` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `moneda` enum('BOB','USD','PYG','BRL') DEFAULT 'BOB',
  `estado` tinyint(1) DEFAULT 1,
  `observaciones` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id`, `sucursal_id`, `usuario_id`, `cliente_id`, `apertura_caja_id`, `fecha_venta`, `descuento`, `total`, `moneda`, `estado`, `observaciones`, `created_at`) VALUES
(1, 2, 1, 1, 1, '2026-05-19 17:24:31', 0.00, 38.00, 'BOB', 1, NULL, '2026-05-19 17:24:31'),
(2, 2, 3, 1, 2, '2026-05-19 17:28:57', 0.00, 76.00, 'BOB', 1, NULL, '2026-05-19 17:28:57'),
(3, 2, 3, 1, 3, '2026-05-19 17:43:56', 0.00, 190.00, 'BOB', 1, NULL, '2026-05-19 17:43:56'),
(4, 2, 1, 1, 4, '2026-05-19 18:13:27', -0.02, 80.02, 'BOB', 1, NULL, '2026-05-19 18:13:27'),
(5, 1, 2, 1, 5, '2026-05-20 12:12:37', -0.02, 118.02, 'BOB', 1, NULL, '2026-05-20 12:12:37'),
(6, 2, 1, 1, 4, '2026-05-20 17:09:49', 0.00, 76.00, 'BOB', 1, NULL, '2026-05-20 17:09:49'),
(7, 1, 2, 1, 6, '2026-05-21 10:07:58', 0.00, 194.00, 'BOB', 1, NULL, '2026-05-21 10:07:58'),
(8, 2, 1, 1, 4, '2026-05-25 14:16:55', 0.00, 38.00, 'BOB', 1, NULL, '2026-05-25 14:16:55'),
(9, 1, 2, NULL, 7, '2026-05-25 17:52:42', 0.00, 38.00, 'BOB', 1, NULL, '2026-05-25 17:52:42'),
(10, 2, 2, 1, 8, '2026-05-25 22:11:21', 0.00, 76.00, 'BOB', 1, NULL, '2026-05-25 22:11:21'),
(11, 1, 2, NULL, 9, '2026-05-25 22:24:32', 0.00, 80.00, 'BOB', 1, NULL, '2026-05-25 22:24:32'),
(12, 1, 2, NULL, 9, '2026-05-25 22:34:21', 0.00, 76.00, 'BOB', 1, NULL, '2026-05-25 22:34:21'),
(13, 1, 2, NULL, 9, '2026-05-25 22:37:04', 0.00, 80.00, 'BOB', 1, NULL, '2026-05-25 22:37:04'),
(14, 2, 2, 1, 10, '2026-05-25 23:54:30', 0.00, 118.00, 'BOB', 1, NULL, '2026-05-25 23:54:30'),
(15, 2, 2, 1, 11, '2026-05-26 12:03:26', 0.00, 76.00, 'BOB', 1, NULL, '2026-05-26 12:03:26'),
(16, 1, 3, NULL, 12, '2026-05-26 17:07:25', 0.00, 38.00, 'BOB', 1, NULL, '2026-05-26 17:07:25'),
(17, 1, 3, 2, 13, '2026-06-02 10:38:33', 0.00, 114.00, 'BOB', 1, NULL, '2026-06-02 10:38:33'),
(18, 1, 3, 3, 13, '2026-06-03 16:25:09', 0.00, 38.00, 'BOB', 1, NULL, '2026-06-03 16:25:09'),
(19, 1, 3, 2, 13, '2026-06-03 16:27:42', 0.00, 190.00, 'BOB', 1, NULL, '2026-06-03 16:27:42');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta_detalle`
--

CREATE TABLE `venta_detalle` (
  `id` int(11) NOT NULL,
  `venta_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL CHECK (`cantidad` > 0),
  `precio_unitario` decimal(10,2) NOT NULL,
  `descuento_linea` decimal(10,2) DEFAULT 0.00,
  `subtotal_linea` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `venta_detalle`
--

INSERT INTO `venta_detalle` (`id`, `venta_id`, `producto_id`, `cantidad`, `precio_unitario`, `descuento_linea`, `subtotal_linea`) VALUES
(1, 1, 1, 1, 38.00, 0.00, 38.00),
(2, 2, 1, 2, 38.00, 0.00, 76.00),
(3, 3, 1, 5, 38.00, 0.00, 190.00),
(4, 4, 2, 1, 80.00, 0.00, 80.00),
(5, 5, 2, 1, 80.00, 0.00, 80.00),
(6, 5, 1, 1, 38.00, 0.00, 38.00),
(7, 6, 1, 2, 38.00, 0.00, 76.00),
(8, 7, 2, 1, 80.00, 0.00, 80.00),
(9, 7, 1, 3, 38.00, 0.00, 114.00),
(10, 8, 1, 1, 38.00, 0.00, 38.00),
(11, 9, 1, 1, 38.00, 0.00, 38.00),
(12, 10, 1, 2, 38.00, 0.00, 76.00),
(13, 11, 2, 1, 80.00, 0.00, 80.00),
(14, 12, 1, 2, 38.00, 0.00, 76.00),
(15, 13, 2, 1, 80.00, 0.00, 80.00),
(16, 14, 1, 1, 38.00, 0.00, 38.00),
(17, 14, 2, 1, 80.00, 0.00, 80.00),
(18, 15, 1, 2, 38.00, 0.00, 76.00),
(19, 16, 1, 1, 38.00, 0.00, 38.00),
(20, 17, 1, 3, 38.00, 0.00, 114.00),
(21, 18, 1, 1, 38.00, 0.00, 38.00),
(22, 19, 1, 5, 38.00, 0.00, 190.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta_pagos`
--

CREATE TABLE `venta_pagos` (
  `id` int(11) NOT NULL,
  `venta_id` int(11) NOT NULL,
  `metodo_pago_id` int(11) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `fecha_pago` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `venta_pagos`
--

INSERT INTO `venta_pagos` (`id`, `venta_id`, `metodo_pago_id`, `monto`, `referencia`, `fecha_pago`) VALUES
(1, 1, 5, 38.00, NULL, '2026-05-19 17:24:31'),
(2, 2, 5, 76.00, NULL, '2026-05-19 17:28:57'),
(3, 3, 6, 190.00, NULL, '2026-05-19 17:43:56'),
(4, 4, 6, 80.02, NULL, '2026-05-19 18:13:27'),
(5, 5, 6, 118.02, NULL, '2026-05-20 12:12:37'),
(6, 6, 5, 76.00, NULL, '2026-05-20 17:09:49'),
(7, 7, 8, 194.00, NULL, '2026-05-21 10:07:58'),
(8, 8, 6, 38.00, NULL, '2026-05-25 14:16:55'),
(9, 9, 5, 38.00, NULL, '2026-05-25 17:52:42'),
(10, 10, 5, 76.00, NULL, '2026-05-25 22:11:21'),
(11, 11, 5, 80.00, NULL, '2026-05-25 22:24:32'),
(12, 12, 6, 76.00, NULL, '2026-05-25 22:34:21'),
(13, 13, 5, 80.00, NULL, '2026-05-25 22:37:04'),
(14, 14, 6, 118.00, NULL, '2026-05-25 23:54:30'),
(15, 15, 5, 76.00, NULL, '2026-05-26 12:03:26'),
(16, 16, 5, 38.00, NULL, '2026-05-26 17:07:25'),
(17, 17, 6, 114.00, NULL, '2026-06-02 10:38:33'),
(18, 18, 5, 38.00, NULL, '2026-06-03 16:25:09'),
(19, 19, 6, 190.00, NULL, '2026-06-03 16:27:42');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `apertura_caja`
--
ALTER TABLE `apertura_caja`
  ADD PRIMARY KEY (`id`),
  ADD KEY `caja_id` (`caja_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `cajas`
--
ALTER TABLE `cajas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sucursal_id` (`sucursal_id`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cierre_caja`
--
ALTER TABLE `cierre_caja`
  ADD PRIMARY KEY (`id`),
  ADD KEY `apertura_caja_id` (`apertura_caja_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `logs_actividad`
--
ALTER TABLE `logs_actividad`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `metodos_pago`
--
ALTER TABLE `metodos_pago`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `popups`
--
ALTER TABLE `popups`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoria_id` (`categoria_id`),
  ADD KEY `sucursal_id` (`sucursal_id`);

--
-- Indices de la tabla `producto_fotos`
--
ALTER TABLE `producto_fotos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- Indices de la tabla `sucursales`
--
ALTER TABLE `sucursales`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `sucursal_fotos`
--
ALTER TABLE `sucursal_fotos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sucursal_id` (`sucursal_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario` (`usuario`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sucursal_id` (`sucursal_id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `cliente_id` (`cliente_id`),
  ADD KEY `apertura_caja_id` (`apertura_caja_id`);

--
-- Indices de la tabla `venta_detalle`
--
ALTER TABLE `venta_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `venta_id` (`venta_id`),
  ADD KEY `producto_id` (`producto_id`);

--
-- Indices de la tabla `venta_pagos`
--
ALTER TABLE `venta_pagos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `venta_id` (`venta_id`),
  ADD KEY `metodo_pago_id` (`metodo_pago_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `apertura_caja`
--
ALTER TABLE `apertura_caja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `cajas`
--
ALTER TABLE `cajas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `cierre_caja`
--
ALTER TABLE `cierre_caja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `logs_actividad`
--
ALTER TABLE `logs_actividad`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=196;

--
-- AUTO_INCREMENT de la tabla `metodos_pago`
--
ALTER TABLE `metodos_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `popups`
--
ALTER TABLE `popups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `producto_fotos`
--
ALTER TABLE `producto_fotos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `sucursales`
--
ALTER TABLE `sucursales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `sucursal_fotos`
--
ALTER TABLE `sucursal_fotos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `venta_detalle`
--
ALTER TABLE `venta_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `venta_pagos`
--
ALTER TABLE `venta_pagos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `apertura_caja`
--
ALTER TABLE `apertura_caja`
  ADD CONSTRAINT `apertura_caja_ibfk_1` FOREIGN KEY (`caja_id`) REFERENCES `cajas` (`id`),
  ADD CONSTRAINT `apertura_caja_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `cajas`
--
ALTER TABLE `cajas`
  ADD CONSTRAINT `cajas_ibfk_1` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`);

--
-- Filtros para la tabla `cierre_caja`
--
ALTER TABLE `cierre_caja`
  ADD CONSTRAINT `cierre_caja_ibfk_1` FOREIGN KEY (`apertura_caja_id`) REFERENCES `apertura_caja` (`id`),
  ADD CONSTRAINT `cierre_caja_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `logs_actividad`
--
ALTER TABLE `logs_actividad`
  ADD CONSTRAINT `logs_actividad_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `productos_ibfk_2` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `producto_fotos`
--
ALTER TABLE `producto_fotos`
  ADD CONSTRAINT `producto_fotos_ibfk_1` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `sucursal_fotos`
--
ALTER TABLE `sucursal_fotos`
  ADD CONSTRAINT `sucursal_fotos_ibfk_1` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`),
  ADD CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `ventas_ibfk_3` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `ventas_ibfk_4` FOREIGN KEY (`apertura_caja_id`) REFERENCES `apertura_caja` (`id`);

--
-- Filtros para la tabla `venta_detalle`
--
ALTER TABLE `venta_detalle`
  ADD CONSTRAINT `venta_detalle_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `venta_detalle_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`);

--
-- Filtros para la tabla `venta_pagos`
--
ALTER TABLE `venta_pagos`
  ADD CONSTRAINT `venta_pagos_ibfk_1` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `venta_pagos_ibfk_2` FOREIGN KEY (`metodo_pago_id`) REFERENCES `metodos_pago` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
