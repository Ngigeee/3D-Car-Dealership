-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Sep 08, 2026 at 08:47 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cardealership`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT '../images/avatar.jpg',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `password`, `avatar`, `created_at`) VALUES
(1, 'dancan', 'ngigidancan227@gmail.com', '$2b$10$DO2.dqWAHwIIxWm0saFBcuZ9csRxNu3hBTNf5o3l2Li2Ethr5jn12', '../images/avatar.jpg', '2025-03-30 17:12:49');

-- --------------------------------------------------------

--
-- Table structure for table `cars`
--

CREATE TABLE `cars` (
  `id` int(11) NOT NULL,
  `brand` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  `year` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `mileage` decimal(10,2) NOT NULL,
  `fuel_type` enum('petrol','diesel','electric') NOT NULL,
  `transmission` enum('manual','automatic','hybrid') NOT NULL,
  `color` varchar(50) NOT NULL DEFAULT 'red',
  `image_path` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '../images/image1.jpg',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cars`
--

INSERT INTO `cars` (`id`, `brand`, `model`, `year`, `price`, `mileage`, `fuel_type`, `transmission`, `color`, `image_path`, `created_at`, `updated_at`, `status`) VALUES
(1, 'Kia', 'optima', 2021, 25000.00, 15000.00, 'petrol', 'automatic', 'blue', '../images/optima.jpg', '2025-03-21 16:32:37', '2025-04-02 04:29:39', 'bestselling'),
(2, 'bugatti', 'chiron', 2020, 23000.00, 18000.00, 'petrol', 'manual', 'silver', '../images/bugatti.jpg', '2025-03-21 16:32:37', '2025-04-02 04:32:06', 'bestselling'),
(3, 'bentley', 'Focus', 2020, 20000.00, 22000.00, 'diesel', 'automatic', 'white', '../images/bentley.jpg', '2025-03-21 16:32:37', '2025-04-02 04:32:44', 'bestselling'),
(4, 'Toyota-gr-supra', 'supra', 2023, 40000.00, 5000.00, 'petrol', 'automatic', 'black', '../images/supra.jpg', '2025-03-21 16:32:37', '2025-04-02 04:33:37', 'bestselling'),
(5, 'mazda_rx-7', 'mazda', 2020, 40000.00, 12000.00, 'diesel', 'manual', 'red', '../images/mazda.jpg', '2025-03-21 16:32:37', '2025-04-02 04:34:22', 'bestselling'),
(6, 'corvetteStingray', 'corvette', 2019, 22000.00, 25000.00, 'petrol', 'automatic', 'gold', '../images/corvette.jpg', '2025-03-21 16:32:37', '2025-04-02 04:35:14', 'bestselling'),
(7, 'Audi_rs5', 'audi', 2022, 27000.00, 8000.00, 'petrol', 'automatic', 'green', '../images/audirs5.jpg', '2025-03-21 16:32:37', '2025-04-02 04:36:37', 'bestselling'),
(8, 'AudiA5', 'audi', 2021, 21000.00, 14000.00, 'petrol', 'manual', 'purple', '../images/audia5.jpg', '2025-03-21 16:32:37', '2025-04-02 04:36:54', 'bestselling'),
(9, 'lamborghini', 'peugeot', 2020, 24000.00, 19000.00, 'diesel', 'automatic', 'orange', '../images/lambo.jpg', '2025-03-21 16:32:37', '2025-04-02 04:55:19', 'bestselling'),
(10, 'Tesla', 'Model 3', 2023, 50000.00, 2000.00, 'electric', 'automatic', 'white', '../images/model3.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:38', 'newest'),
(11, 'Subaru', 'Impreza', 2019, 23000.00, 30000.00, 'petrol', 'manual', 'yellow', '../images/impreza.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:39', 'newest'),
(12, 'Mazda', 'Mazda3', 2021, 26000.00, 12000.00, 'petrol', 'automatic', 'brown', '../images/mazda3.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:39', 'newest'),
(13, 'Volkswagen', 'Jetta', 2020, 22000.00, 18000.00, 'petrol', 'manual', 'cyan', '../images/jetta.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:39', 'newest'),
(14, 'Volvo', 'S60', 2022, 41000.00, 7000.00, 'diesel', 'automatic', 'magenta', '../images/s60.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:39', 'newest'),
(15, 'Lexus', 'ES', 2021, 45000.00, 9000.00, 'petrol', 'automatic', 'lime', '../images/es.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:39', 'trending'),
(16, 'Jeep', 'Grand Cherokee', 2019, 35000.00, 28000.00, 'petrol', 'automatic', 'teal', '../images/grandcherokee.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:39', 'trending'),
(17, 'Dodge', 'Charger', 2020, 37000.00, 16000.00, 'diesel', 'manual', 'olive', '../images/charger.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:39', 'trending'),
(18, 'Porsche', 'Panamera', 2022, 90000.00, 4000.00, 'petrol', 'automatic', 'maroon', '../images/panamera.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:39', 'trending'),
(19, 'ford', 'civic', 2018, 250000.00, 5000.00, 'diesel', 'automatic', 'navy', '../images/image1.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:39', 'trending'),
(20, 'Lamborghini', 'Huracan', 2019, 300000.00, 8000.00, 'petrol', 'automatic', 'aqua', '../images/huracan.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:39', NULL),
(21, 'McLaren', '720S', 2021, 280000.00, 3000.00, 'petrol', 'automatic', 'fuchsia', '../images/720s.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:39', NULL),
(22, 'Bugatti', 'Chiron', 2023, 3500000.00, 1000.00, 'petrol', 'automatic', 'silver', '../images/chiron.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:40', NULL),
(23, 'Rolls-Royce', 'Ghost', 2020, 450000.00, 6000.00, 'petrol', 'automatic', 'gold', '../images/ghost.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:40', NULL),
(24, 'Bentley', 'Continental', 2021, 320000.00, 7000.00, 'petrol', 'automatic', 'green', '../images/continental.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:40', NULL),
(25, 'Jaguar', 'XF', 2019, 48000.00, 25000.00, 'diesel', 'automatic', 'purple', '../images/xf.jpg', '2025-03-21 16:32:37', '2025-03-31 10:25:40', NULL),
(26, 'Land Rover', 'Range Rover', 2022, 95000.00, 9000.00, 'petrol', 'automatic', 'orange', '../images/rangerover.jpg', '2025-03-21 16:32:37', '2025-03-31 10:29:16', NULL),
(27, 'Cadillac', 'Escalade', 2021, 85000.00, 11000.00, 'petrol', 'automatic', 'white', '../images/escalade.jpg', '2025-03-21 16:32:37', '2025-03-31 10:29:16', NULL),
(28, 'GMC', 'Yukon', 2020, 75000.00, 14000.00, 'diesel', 'automatic', 'yellow', '../images/yukon.jpg', '2025-03-21 16:32:37', '2025-03-31 10:29:16', NULL),
(29, 'Chrysler', '300', 2019, 37000.00, 22000.00, 'petrol', 'automatic', 'brown', '../images/300.jpg', '2025-03-21 16:32:37', '2025-03-31 10:29:16', NULL),
(30, 'Acura', 'TLX', 2022, 46000.00, 5000.00, 'petrol', 'automatic', 'cyan', '../images/tlx.jpg', '2025-03-21 16:32:37', '2025-03-31 10:29:16', NULL),
(31, 'Infiniti', 'Q50', 2020, 39000.00, 15000.00, 'petrol', 'manual', 'magenta', '../images/q50.jpg', '2025-03-21 16:32:37', '2025-03-31 10:29:16', NULL),
(32, 'Mitsubishi', 'Lancer', 2018, 21000.00, 32000.00, 'petrol', 'manual', 'lime', '../images/lancer.jpg', '2025-03-21 16:32:37', '2025-03-31 10:29:16', NULL),
(33, 'Peugeot', '508', 2019, 33000.00, 27000.00, 'diesel', 'automatic', 'teal', '../images/508.jpg', '2025-03-21 16:32:37', '2025-03-31 10:29:16', NULL),
(34, 'Renault', 'Megane', 2020, 28000.00, 20000.00, 'diesel', 'manual', 'olive', '../images/megane.jpg', '2025-03-21 16:32:37', '2025-03-31 10:29:16', NULL),
(35, 'Fiat', '500', 2021, 18000.00, 10000.00, 'electric', 'automatic', 'maroon', '../images/500.jpg', '2025-03-21 16:32:37', '2025-03-31 10:29:16', NULL),
(36, 'Suzuki', 'Swift', 2019, 16000.00, 29000.00, 'petrol', 'manual', 'navy', '../images/swift.jpg', '2025-03-21 16:32:37', '2025-03-31 10:29:17', NULL),
(37, 'Opel', 'Astra', 2020, 22000.00, 19000.00, 'petrol', 'automatic', 'aqua', '../images/astra.jpg', '2025-03-21 16:32:37', '2025-03-31 10:29:17', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages`
--

CREATE TABLE `contact_messages` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact_messages`
--

INSERT INTO `contact_messages` (`id`, `name`, `email`, `subject`, `message`, `submitted_at`) VALUES
(1, 'Dancan Ngigi', 'ngigidancan227@gmail.com', 'login', 'ggggggggggggg', '2025-04-19 18:43:08'),
(2, 'Dancan Ngigi', 'ngigidancan227@gmail.com', 'Commision', 'ssss', '2025-09-30 09:18:51');

-- --------------------------------------------------------

--
-- Table structure for table `models`
--

CREATE TABLE `models` (
  `id` int(11) NOT NULL,
  `image_path` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `models`
--

INSERT INTO `models` (`id`, `image_path`) VALUES
(1, '../images/kia/scene.gltf'),
(2, '../images/bugatti/scene.gltf'),
(3, '../images/bentley/scene.gltf'),
(4, '../images/toyota_gr_supra/scene.gltf'),
(5, '../images/mazda_rx-7/scene.gltf'),
(6, '../images/corvetteStingray/scene.gltf'),
(7, '../images/audi_rs5/scene.gltf'),
(8, '../images/AudiA52021/scene.gltf'),
(9, '../images/peugeot/scene.gltf'),
(10, '../images/tesla/scene.gltf');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `owner_name` varchar(200) NOT NULL,
  `carImage_path` varchar(200) NOT NULL,
  `brand` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `order_status` varchar(200) NOT NULL DEFAULT 'placed',
  `payment_method` varchar(255) DEFAULT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `customization` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `owner_id`, `owner_name`, `carImage_path`, `brand`, `model`, `year`, `price`, `color`, `order_status`, `payment_method`, `order_date`, `customization`) VALUES
(1, 0, '', '', 'Toyota', 'Corolla', 2021, 25000.00, 'red', 'placed', 'credit', '2025-03-22 08:47:46', ''),
(2, 0, '', '', 'Ford', 'Focus', 2019, 20000.00, 'green', 'Rejected', 'credit', '2025-03-22 08:53:44', ''),
(12, 12, 'Dancan Ngigi', '../images/civic.jpg', 'toyota', 'Civic', 2020, 23000.00, 'green', 'deleted', 'credit', '2025-03-25 09:36:11', ''),
(13, 13, 'samuel Ngune', '../images/a4.jpg', 'Audi', 'A4', 2020, 38000.00, 'red', 'placed', 'credit', '2025-03-25 11:36:06', ''),
(14, 14, 'joram nduati', '../images/civic.jpg', 'toyota', 'Civic', 2020, 23000.00, 'red', 'placed', 'credit', '2025-03-25 11:40:49', ''),
(15, 15, 'samuel Ngunenduati', '../images/malibu.jpg', 'Chevrolet', 'Malibu', 2022, 27000.00, 'indigo', 'placed', 'credit', '2025-03-25 11:44:31', ''),
(16, 16, 'Dancan Ngigi', '../images/elantra.jpg', 'Hyundai', 'Elantra', 2021, 21000.00, 'orange', 'placed', 'credit', '2025-03-25 12:06:20', ''),
(17, 17, 'Dancan Ngigi', '../images/cclass.jpg', 'Mercedes', 'C-Class', 2021, 42000.00, 'radadadd', 'placed', 'credit', '2025-03-25 12:35:24', ''),
(18, 2, 'Dancan Ngigi', '../images/civic.jpg', 'toyota', 'Civic', 2020, 23000.00, 'indigo', 'placed', 'credit', '2025-03-26 08:33:45', ''),
(20, 7, 'joram nduati', '../images/corolla.jpg', 'Toyota', 'Corolla', 2021, 25000.00, 'orange', 'placed', 'credit', '2025-03-26 11:39:48', ''),
(21, 10, 'Dancan Ngigi', '../images/fordfocus.jpg', 'Ford', 'Focus', 2019, 20000.00, 'orange', 'placed', 'credit', '2025-03-26 11:49:26', ''),
(22, 13, 'samuel Ngunenduati', '../images/civic.jpg', 'toyota', 'Civic', 2020, 23000.00, 'indigo', 'placed', 'credit', '2025-03-26 20:21:30', ''),
(23, 1, 'myName', '../images/altima.jpg', 'Nissan', 'Altima', 2019, 22000.00, 'green', 'placed', 'credit', '2025-03-27 18:46:53', ''),
(24, 1, 'myName', '../images/corolla.jpg', 'Toyota', 'Corolla', 2021, 25000.00, 'red', 'deleted', 'debit', '2025-03-27 18:57:14', ''),
(25, 1, 'myName', '../images/corolla.jpg', 'Toyota', 'Corolla', 2021, 25000.00, 'green', 'placed', 'credit', '2025-03-29 09:17:41', ''),
(27, 1, 'myName', '../images/altima.jpg', 'Nissan', 'Altima', 2019, 22000.00, 'orange', 'placed', 'paypal', '2025-03-29 11:24:14', ''),
(28, 5, 'robin', '../images/corolla.jpg', 'Toyota', 'corolla', 2021, 25000.00, 'green', 'placed', 'credit', '2025-04-01 00:34:00', ''),
(29, 1, 'das', '../images/corolla.jpg', 'Toyota', 'corolla', 2021, 25000.00, 'indigo', 'placed', 'debit', '2025-04-01 01:42:50', ''),
(30, 1, 'das', '../images/corolla.jpg', 'Toyota', 'corolla', 2021, 25000.00, 'red', 'placed', 'paypal', '2025-04-01 01:44:00', ''),
(32, 6, 'maxon', '../images/fordfocus.jpg', 'Ford', 'Focus', 2020, 20000.00, 'green', 'deleted', 'credit', '2025-04-02 03:46:54', ''),
(33, 6, 'maxon', '../images/optima.jpg', 'Kia', 'optima', 2021, 25000.00, 'green', 'placed', 'credit', '2025-04-02 06:45:42', 'iwant red rims'),
(34, 6, 'maxon', '../images/mazda.jpg', 'mazda_rx-7', 'mazda', 2020, 40000.00, 'radadadd', 'placed', 'paypal', '2025-04-19 18:38:18', 'iwant red rims'),
(35, 6, 'maxon', '../images/optima.jpg', 'Kia', 'optima', 2021, 25000.00, 'green', 'placed', 'paypal', '2025-05-16 08:41:32', 'i want  blue wheels  '),
(36, 7, 'alloooo', '../images/xf.jpg', 'Jaguar', 'XF', 2019, 48000.00, 'green', 'placed', 'paypal', '2025-08-28 18:20:25', 'i want  blue wheels  '),
(37, 8, 'ngigee', '../images/optima.jpg', 'Kia', 'optima', 2021, 25000.00, 'green', 'placed', 'debit', '2025-09-30 09:18:03', 'i want  blue wheels  ');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `Car_cost` decimal(10,2) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `payment_status` varchar(50) DEFAULT 'Pending',
  `date_paid` timestamp NULL DEFAULT NULL,
  `balance` decimal(10,2) DEFAULT 0.00,
  `amount_paid` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `owner_id`, `order_id`, `payment_method`, `Car_cost`, `location`, `name`, `phone`, `payment_status`, `date_paid`, `balance`, `amount_paid`) VALUES
(1, 1, 1, 'credit', 22000.00, 'kutus', 'Dancan', '0798171482', 'completed', '2025-03-27 18:47:19', 2000.00, 20000.00),
(2, 1, 1, 'debit', 25000.00, 'kutus', 'Dancan', '0798171482', 'cancelled', '2025-03-27 18:57:40', 22000.00, 3000.00),
(3, 1, 1, 'credit', 25000.00, 'Nairobi', 'Dancan', '0798171482', 'cancelled', '2025-03-29 09:18:16', 21001.00, 3999.00),
(4, 4, 1, 'credit', 40000.00, 'Nairobi', 'sonny', '0713709531', 'cancelled', '2025-03-29 10:13:27', 0.00, 40000.00),
(5, 1, 2, 'credit', 25000.00, 'Nairobi', 'Dancan', '0798171482', 'completed', '2025-03-29 11:24:53', 0.00, 25000.00),
(6, 1, 1, 'paypal', 25000.00, 'Nairobi', 'Dancan', '0798171482', 'Pending', '2025-04-01 01:44:55', 22000.00, 3000.00),
(7, 6, 1, 'paypal', 40000.00, 'Nairobi', 'dancam', '0798171482', 'cancelled', '2025-04-19 18:38:48', 6656.00, 33344.00),
(8, 6, 1, 'paypal', 25000.00, 'kenya', 'john', '0712345678', 'Pending', '2025-05-16 08:42:11', 0.00, 25000.00),
(9, 6, 1, 'paypal', 25000.00, 'kenya', 'Dancan Ngigi', '0712345678', 'Pending', '2025-05-26 11:30:57', -15000.00, 40000.00),
(10, 6, 1, 'paypal', 25000.00, 'kenya', 'Dancan Ngigi', '254798171482', 'Pending', '2025-05-26 11:47:03', 22800.00, 2200.00),
(11, 6, 1, 'paypal', 25000.00, 'kenya', 'Dancan Ngigi', '254798171482', 'Pending', '2025-05-26 11:48:51', 23000.00, 2000.00),
(12, 6, 1, 'paypal', 25000.00, 'kenya', 'Dancan Ngigi', '+254798171482', 'Pending', '2025-05-26 11:51:25', 23000.00, 2000.00),
(13, 6, 1, 'paypal', 25000.00, 'kenya', 'Dancan Ngigi', '254798171482', 'Pending', '2025-05-26 11:52:12', 23000.00, 2000.00),
(14, 8, 1, 'debit', 25000.00, 'kirinyaga', 'Dancan Ngigi', '254798171482', 'Pending', '2025-09-30 09:21:00', 0.00, 25000.00);

-- --------------------------------------------------------

--
-- Table structure for table `search_log`
--

CREATE TABLE `search_log` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `car_id` int(11) DEFAULT NULL,
  `search_timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `search_log`
--

INSERT INTO `search_log` (`log_id`, `user_id`, `car_id`, `search_timestamp`) VALUES
(1, 1, 95, '2025-03-27 18:56:18'),
(2, 1, 95, '2025-03-27 18:56:25'),
(3, 1, 97, '2025-03-27 18:56:32'),
(4, 1, 98, '2025-03-27 18:56:37'),
(5, 1, 117, '2025-03-28 08:10:32'),
(6, 1, 117, '2025-03-28 08:10:33'),
(7, 1, 117, '2025-03-28 08:10:33'),
(8, 1, 105, '2025-03-28 08:10:33'),
(9, 1, 129, '2025-03-28 08:10:33'),
(10, 1, 105, '2025-03-28 08:10:36'),
(11, 1, 117, '2025-03-28 08:10:36'),
(12, 1, 117, '2025-03-28 08:10:37'),
(13, 1, 117, '2025-03-28 08:10:37'),
(14, 1, 117, '2025-03-28 08:10:38'),
(15, 1, 117, '2025-03-28 08:10:39'),
(16, 1, 117, '2025-03-28 08:10:39'),
(17, 1, 105, '2025-03-28 08:10:39'),
(18, 1, 129, '2025-03-28 08:10:40'),
(19, 5, 1, '2025-04-01 00:35:24'),
(20, 5, 3, '2025-04-01 00:35:30'),
(21, 5, 36, '2025-04-01 00:35:48'),
(22, 5, 1, '2025-04-01 00:36:09'),
(23, 5, 22, '2025-04-01 00:36:35'),
(24, 5, 22, '2025-04-01 00:36:35'),
(25, 5, 22, '2025-04-01 00:36:36'),
(26, 5, 10, '2025-04-01 00:36:36'),
(27, 5, 34, '2025-04-01 00:36:37'),
(28, 5, 1, '2025-04-01 00:36:46'),
(29, 1, 1, '2025-04-01 01:47:20'),
(30, 1, 3, '2025-04-01 01:47:26'),
(31, 1, 1, '2025-04-01 01:47:34'),
(32, 1, 3, '2025-04-01 01:47:46'),
(33, 1, 3, '2025-04-01 01:48:03'),
(34, 1, 3, '2025-04-01 01:48:10'),
(35, 1, 22, '2025-04-01 01:48:25'),
(36, 1, 22, '2025-04-01 01:48:26'),
(37, 1, 22, '2025-04-01 01:48:26'),
(38, 1, 10, '2025-04-01 01:48:26'),
(39, 1, 34, '2025-04-01 01:48:28'),
(40, 1, 1, '2025-04-01 01:48:31'),
(41, 1, 3, '2025-04-01 01:48:34'),
(42, 6, 1, '2025-04-02 03:38:16'),
(43, 6, 3, '2025-04-02 03:38:29'),
(44, 6, 3, '2025-04-02 06:08:25'),
(45, 6, 19, '2025-04-02 06:08:44'),
(46, 6, 1, '2025-04-02 06:08:52'),
(47, 6, 22, '2025-04-02 06:09:14'),
(48, 6, 22, '2025-04-02 06:09:15'),
(49, 6, 22, '2025-04-02 06:09:15'),
(50, 6, 21, '2025-04-02 06:09:15'),
(51, 6, 11, '2025-04-02 06:09:16'),
(52, 6, 21, '2025-04-02 06:09:18'),
(53, 6, 22, '2025-04-02 06:09:18'),
(54, 6, 22, '2025-04-02 06:09:19'),
(55, 6, 22, '2025-04-02 06:09:19'),
(56, 6, 22, '2025-04-02 06:09:20'),
(57, 6, 22, '2025-04-02 06:09:21'),
(58, 6, 22, '2025-04-02 06:09:21'),
(59, 6, 21, '2025-04-02 06:09:21'),
(60, 6, 11, '2025-04-02 06:09:22'),
(61, 6, 21, '2025-04-02 06:09:27'),
(62, 6, 22, '2025-04-02 06:09:27'),
(63, 6, 22, '2025-04-02 06:09:27'),
(64, 6, 22, '2025-04-02 06:09:27'),
(65, 6, 1, '2025-04-02 06:12:54'),
(66, 6, 10, '2025-04-02 06:16:43'),
(67, 6, 4, '2025-04-02 06:16:45'),
(68, 6, 10, '2025-04-02 06:16:46'),
(69, 6, 10, '2025-04-02 06:16:47'),
(70, 6, 4, '2025-04-02 06:16:49'),
(71, 6, 4, '2025-04-02 06:16:50'),
(72, 6, 4, '2025-04-02 06:16:51'),
(73, 6, 4, '2025-04-02 06:16:52'),
(74, 6, 4, '2025-04-02 06:16:53'),
(75, 6, 4, '2025-04-02 06:16:54'),
(76, 6, 4, '2025-04-02 06:16:54'),
(77, 6, 4, '2025-04-02 06:16:54'),
(78, 6, 4, '2025-04-02 06:16:55'),
(79, 6, 10, '2025-04-02 06:16:55'),
(80, 6, 17, '2025-04-02 06:16:58'),
(81, 6, 19, '2025-04-02 06:16:58'),
(82, 6, 19, '2025-04-02 06:17:01'),
(83, 6, 19, '2025-04-02 06:17:01'),
(84, 6, 19, '2025-04-02 06:17:02'),
(85, 6, 19, '2025-04-02 06:17:03'),
(86, 6, 19, '2025-04-02 06:17:03'),
(87, 6, 19, '2025-04-02 06:17:04'),
(88, 6, 17, '2025-04-02 06:17:04'),
(89, 6, 3, '2025-04-19 18:39:37'),
(90, 6, 2, '2025-04-19 18:39:39'),
(91, 6, 2, '2025-04-19 18:39:39'),
(92, 6, 2, '2025-04-19 18:39:39'),
(93, 6, 2, '2025-04-19 18:39:41'),
(94, 6, 2, '2025-04-19 18:39:41'),
(95, 6, 2, '2025-04-19 18:39:45'),
(96, 6, 2, '2025-04-19 18:39:47'),
(97, 6, 2, '2025-04-19 18:39:53'),
(98, 6, 2, '2025-04-19 18:39:54'),
(99, 6, 2, '2025-04-19 18:39:54'),
(100, 6, 2, '2025-04-19 18:39:54'),
(101, 6, 2, '2025-04-19 18:39:55'),
(102, 6, 3, '2025-04-19 18:39:55'),
(103, 6, 3, '2025-04-19 18:40:00'),
(104, 6, 3, '2025-04-19 18:40:01'),
(105, 6, 3, '2025-04-19 18:40:02'),
(106, 6, 3, '2025-04-19 18:40:02'),
(107, 6, 3, '2025-04-19 18:40:02'),
(108, 6, 3, '2025-04-19 18:40:03'),
(109, 6, 3, '2025-04-19 18:40:04'),
(110, 6, 3, '2025-04-19 18:40:10'),
(111, 6, 3, '2025-04-19 18:40:10'),
(112, 6, 3, '2025-04-19 18:40:10'),
(113, 6, 3, '2025-04-19 18:40:10'),
(114, 6, 3, '2025-04-19 18:40:10'),
(115, 6, 3, '2025-04-19 18:40:10'),
(116, 6, 3, '2025-04-19 18:40:12'),
(117, 6, 3, '2025-04-19 18:40:13'),
(118, 6, 3, '2025-04-19 18:40:14'),
(119, 6, 3, '2025-04-19 18:40:14'),
(120, 6, 3, '2025-04-19 18:40:14'),
(121, 6, 3, '2025-04-19 18:40:15'),
(122, 6, 3, '2025-04-19 18:40:16'),
(123, 6, 3, '2025-04-19 18:40:17'),
(124, 6, 3, '2025-04-19 18:40:18'),
(125, 6, 3, '2025-04-19 18:40:18'),
(126, 6, 3, '2025-04-19 18:40:18'),
(127, 6, 3, '2025-04-19 18:40:18'),
(128, 6, 3, '2025-04-19 18:40:18'),
(129, 6, 12, '2025-04-19 18:40:19'),
(130, 6, 12, '2025-04-19 18:40:20'),
(131, 6, 12, '2025-04-19 18:40:20'),
(132, 6, 12, '2025-04-19 18:40:20'),
(133, 6, 12, '2025-04-19 18:40:21'),
(134, 6, 12, '2025-04-19 18:40:24'),
(135, 6, 12, '2025-04-19 18:40:25'),
(136, 6, 12, '2025-04-19 18:40:25'),
(137, 6, 12, '2025-04-19 18:40:25'),
(138, 6, 12, '2025-04-19 18:40:27'),
(139, 6, 12, '2025-04-19 18:40:27'),
(140, 6, 12, '2025-04-19 18:40:28'),
(141, 6, 12, '2025-04-19 18:40:29'),
(142, 6, 12, '2025-04-19 18:40:29'),
(143, 6, 12, '2025-04-19 18:40:30'),
(144, 6, 12, '2025-04-19 18:40:31'),
(145, 6, 12, '2025-04-19 18:40:31'),
(146, 6, 12, '2025-04-19 18:40:31'),
(147, 6, 11, '2025-04-19 18:40:55'),
(148, 6, 3, '2025-04-19 18:41:03'),
(149, 6, 36, '2025-04-19 18:41:09'),
(150, 6, 17, '2025-04-19 18:41:29'),
(151, 6, 1, '2025-04-19 18:41:40'),
(152, 6, 27, '2025-05-16 08:43:25'),
(153, 6, 1, '2025-05-16 08:43:30'),
(154, 6, 1, '2025-05-16 08:43:30'),
(155, 6, 1, '2025-05-16 08:43:31'),
(156, 6, 1, '2025-05-16 08:43:37'),
(157, 6, 1, '2025-05-16 08:43:37'),
(158, 6, 30, '2025-05-16 08:43:40'),
(159, 6, 8, '2025-05-16 08:43:40'),
(160, 6, 8, '2025-05-16 08:43:40'),
(161, 6, 8, '2025-05-16 08:43:41'),
(162, 6, 8, '2025-05-16 08:43:44'),
(163, 6, 8, '2025-05-16 08:43:44'),
(164, 6, 30, '2025-05-16 08:43:44'),
(165, 6, 17, '2025-05-16 08:43:46'),
(166, 6, 19, '2025-05-16 08:43:47'),
(167, 6, 19, '2025-05-16 08:43:48'),
(168, 6, 19, '2025-05-16 08:43:48'),
(169, 6, 19, '2025-05-16 08:43:49'),
(170, 6, 19, '2025-05-16 08:43:56'),
(171, 6, 19, '2025-05-16 08:43:56'),
(172, 6, 19, '2025-05-16 08:43:56'),
(173, 6, 17, '2025-05-16 08:43:56'),
(174, 8, 3, '2025-09-30 09:15:01'),
(175, 8, 36, '2025-09-30 09:15:18'),
(176, 8, 1, '2025-09-30 09:23:01');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `hashedpassword` varchar(255) NOT NULL,
  `address` varchar(200) NOT NULL,
  `profileImg` varchar(200) NOT NULL DEFAULT '../images/avatar.jpg',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `hashedpassword`, `address`, `profileImg`, `created_at`, `updated_at`) VALUES
(1, 'das', '2025-03-27T18:46:11.000Z', 'das', '$2b$10$hqVUFCxF1ekM.Nc/hlJgcOrJAoN3prCObR5hz80mF0vfF2iFNz/Ke', 'kutus kirinyaga', '../images/avatar.jpg', '2025-03-27 18:46:11', '2025-04-01 01:52:23'),
(2, 'das', '$2b$10$9xKny.A72uQgSryRUxr6dOgqPrZniuxfmuCLsQ2ar1U6jyt/QGCHy', 'das', '$2b$10$9xKny.A72uQgSryRUxr6dOgqPrZniuxfmuCLsQ2ar1U6jyt/QGCHy', 'kutus kirinyaga', '../images/avatar.jpg', '2025-03-27 19:10:41', '2025-03-30 15:39:57'),
(3, 'das', '../images/avatar.jpg', 'das', '$2b$10$sMOsUSVvI0BJiAMIjy05vOKMP6D.4cO4qXq2ujx.swAEPMjJfKbwC', 'kutus kirinyaga', '../images/avatar.jpg', '2025-03-27 19:11:47', '2025-03-30 15:40:09'),
(4, 'maxon', 'sonnymax04@gmail.com', '00000000', '$2b$10$JJv2EGb9TbpUm.vXztnwvuqu/Cb.TCr36JRO4NU7YKw42svcDUtjW', 'kutus kirinyaga', '../images/avatar.jpg', '2025-03-29 10:11:46', '2025-03-29 10:11:46'),
(5, 'robin', 'robin254@gmail.com', '000', '$2b$10$rwK3/KJbnoLGTULCcecWVOump5aA5/ujIdAf.18QiufLuh4u67sei', 'robin254', '../images/avatar.jpg', '2025-04-01 00:32:45', '2025-04-01 00:32:45'),
(6, 'maxon', 'ngigidancan228@gmail.com', 'das', '$2b$10$eGww1wIqKwW5M.QtCXWyZOM5wYdIY5jquBAYBGwdlHSBX.EqoQQ0W', 'kutus kirinyaga', '../images/avatar.jpg', '2025-04-01 04:59:07', '2025-04-01 04:59:07'),
(7, 'alloooo', 'ngigidancan450@gmail.com', 'das', '$2b$10$QuE9FxNtYxO1kaJAnb9z.enQs0Bi6IQeRLQ7VI58olIJGI2.JUE/G', 'Nairobi', '../images/avatar.jpg', '2025-08-28 18:14:38', '2025-08-28 18:14:38'),
(8, 'ngigee', 'ngigidancan28@gmail.com', 'Dancan6560', '$2b$10$Qb3j5eTQgXbajiv48lPeR.qFCD2zWKnkMmFO8ws4/uO4.AYFRf6/2', 'Nairobi', '../images/avatar.jpg', '2025-09-30 09:13:54', '2025-09-30 09:13:54'),
(9, 'ngigee', 'ngigidancan22@gmail.com', 'das', '$2b$10$BEdp6vxZRvd0aHb1it6ctOl3DLhwV2CZtyqZpKx2Zo7zlP1.ePZbe', 'Nairobi', '../images/avatar.jpg', '2025-11-01 11:16:17', '2025-11-01 11:16:17');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `cars`
--
ALTER TABLE `cars`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `models`
--
ALTER TABLE `models`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `search_log`
--
ALTER TABLE `search_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `car_id` (`car_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cars`
--
ALTER TABLE `cars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `models`
--
ALTER TABLE `models`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `search_log`
--
ALTER TABLE `search_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=177;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

--
-- Constraints for table `search_log`
--
ALTER TABLE `search_log`
  ADD CONSTRAINT `search_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `search_log_ibfk_2` FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
