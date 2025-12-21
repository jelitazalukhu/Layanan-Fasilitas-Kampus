-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 21, 2025 at 04:26 PM
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
-- Database: `appfasilitaskampus`
--

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `facilityId` int(11) NOT NULL,
  `date` datetime(3) NOT NULL,
  `startTime` int(11) NOT NULL,
  `endTime` int(11) NOT NULL,
  `roomName` varchar(191) DEFAULT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'PENDING',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`id`, `userId`, `facilityId`, `date`, `startTime`, `endTime`, `roomName`, `status`, `createdAt`) VALUES
(1, 1, 2, '2025-12-19 01:05:48.301', 9, 11, NULL, 'CONFIRMED', '2025-12-19 01:05:49.714'),
(2, 1, 2, '2025-12-19 01:06:10.041', 9, 11, NULL, 'CONFIRMED', '2025-12-19 01:06:11.618'),
(3, 1, 1, '2025-12-19 01:45:16.630', 9, 11, 'Ruang Perpustakaan 1', 'CONFIRMED', '2025-12-19 01:45:19.050'),
(4, 1, 2, '2025-12-19 01:45:32.179', 9, 11, NULL, 'CONFIRMED', '2025-12-19 01:45:33.745'),
(5, 1, 2, '2025-12-19 01:47:34.482', 9, 11, NULL, 'CONFIRMED', '2025-12-19 01:47:36.692'),
(6, 1, 1, '2025-12-19 02:05:14.771', 9, 10, 'Ruang Perpustakaan 1', 'CONFIRMED', '2025-12-19 02:05:22.377'),
(7, 1, 2, '2025-12-19 02:06:59.857', 9, 11, NULL, 'CONFIRMED', '2025-12-19 02:07:01.495'),
(8, 1, 2, '2025-12-19 02:51:47.720', 9, 11, NULL, 'CONFIRMED', '2025-12-19 02:51:50.357'),
(9, 1, 2, '2025-12-19 02:52:13.021', 9, 11, NULL, 'CONFIRMED', '2025-12-19 02:52:14.152'),
(10, 1, 2, '2025-12-19 04:40:26.153', 9, 11, NULL, 'CONFIRMED', '2025-12-19 04:40:29.100'),
(11, 1, 1, '2025-12-21 15:18:27.765', 9, 11, 'Ruang Baca A', 'CONFIRMED', '2025-12-21 15:18:29.769'),
(12, 1, 4, '2025-12-21 15:18:54.944', 9, 11, 'Aula Dakwah Utama', 'CONFIRMED', '2025-12-21 15:18:56.872');

-- --------------------------------------------------------

--
-- Table structure for table `facility`
--

CREATE TABLE `facility` (
  `id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` varchar(191) DEFAULT NULL,
  `location` varchar(191) NOT NULL,
  `imageUrl` varchar(191) NOT NULL,
  `category` varchar(191) NOT NULL,
  `openHour` int(11) NOT NULL,
  `closeHour` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `facility`
--

INSERT INTO `facility` (`id`, `name`, `description`, `location`, `imageUrl`, `category`, `openHour`, `closeHour`) VALUES
(1, 'Perpustakaan', 'Perpustakaan pusat dengan fasilitas WiFi dan AC', 'Kampus USU', 'assets/perpustakaan.jpeg', 'Fasilitas Umum', 8, 17),
(2, 'Auditorium', 'Gedung serbaguna untuk acara besar', 'Kampus USU', 'assets/auditorium.webp', 'Fasilitas Umum', 8, 22),
(3, 'Poliklinik', 'Layanan kesehatan untuk mahasiswa', 'Kampus USU', 'assets/poli.jpg', 'Fasilitas Umum', 8, 16),
(4, 'Masjid Kampus', 'Tempat ibadah utama', 'Kampus USU', 'assets/masjid_ar-rahman.jpg', 'Masjid', 4, 22);

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `title` varchar(191) NOT NULL,
  `message` varchar(191) NOT NULL,
  `isRead` tinyint(1) NOT NULL DEFAULT 0,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`id`, `userId`, `title`, `message`, `isRead`, `createdAt`) VALUES
(1, 1, 'Booking Berhasil!', 'Booking Auditorium pada tanggal 2025-12-19 jam 9:00 - 11:00 berhasil.', 0, '2025-12-19 01:05:49.720'),
(2, 1, 'Booking Berhasil!', 'Booking Auditorium pada tanggal 2025-12-19 jam 9:00 - 11:00 berhasil.', 0, '2025-12-19 01:06:11.638'),
(3, 1, 'Booking Berhasil!', 'Booking Perpustakaan - Ruang Perpustakaan 1 pada tanggal 2025-12-19 jam 9:00 - 11:00 berhasil.', 0, '2025-12-19 01:45:19.070'),
(4, 1, 'Booking Berhasil!', 'Booking Auditorium pada tanggal 2025-12-19 jam 9:00 - 11:00 berhasil.', 0, '2025-12-19 01:45:33.767'),
(5, 1, 'Booking Berhasil!', 'Booking Auditorium pada tanggal 2025-12-19 jam 9:00 - 11:00 berhasil.', 0, '2025-12-19 01:47:36.711'),
(6, 1, 'Booking Berhasil!', 'Booking Perpustakaan - Ruang Perpustakaan 1 pada tanggal 2025-12-19 jam 9:00 - 10:00 berhasil.', 0, '2025-12-19 02:05:22.397'),
(7, 1, 'Booking Berhasil!', 'Booking Auditorium pada tanggal 2025-12-19 jam 9:00 - 11:00 berhasil.', 0, '2025-12-19 02:07:01.516'),
(8, 1, 'Booking Berhasil!', 'Booking Auditorium pada tanggal 2025-12-19 jam 9:00 - 11:00 berhasil.', 0, '2025-12-19 02:51:50.379'),
(9, 1, 'Booking Berhasil!', 'Booking Auditorium pada tanggal 2025-12-19 jam 9:00 - 11:00 berhasil.', 0, '2025-12-19 02:52:14.174'),
(10, 1, 'Booking Berhasil!', 'Booking Auditorium pada tanggal 2025-12-19 jam 9:00 - 11:00 berhasil.', 0, '2025-12-19 04:40:29.108'),
(11, 1, 'Booking Berhasil!', 'Booking Perpustakaan - Ruang Baca A pada tanggal 2025-12-21 jam 9:00 - 11:00 berhasil.', 0, '2025-12-21 15:18:29.780'),
(12, 1, 'Booking Berhasil!', 'Booking Masjid Kampus - Aula Dakwah Utama pada tanggal 2025-12-21 jam 9:00 - 11:00 berhasil.', 0, '2025-12-21 15:18:56.877');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `email` varchar(191) NOT NULL,
  `nim` varchar(191) NOT NULL,
  `password` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `avatarUrl` varchar(191) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `email`, `nim`, `password`, `name`, `avatarUrl`, `createdAt`) VALUES
(1, 'mauliamaulia152@gmail.com', '241712009', '$2a$10$r5cJZSO66wIKqXH0ps8Pc.KDinAFoprrhyJoXDbsH7vMzJ3G4ZK2a', 'Maulia Revani Putri', NULL, '2025-12-18 23:30:07.970');

-- --------------------------------------------------------

--
-- Table structure for table `_prisma_migrations`
--

CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) NOT NULL,
  `checksum` varchar(64) NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) NOT NULL,
  `logs` text DEFAULT NULL,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `applied_steps_count` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `_prisma_migrations`
--

INSERT INTO `_prisma_migrations` (`id`, `checksum`, `finished_at`, `migration_name`, `logs`, `rolled_back_at`, `started_at`, `applied_steps_count`) VALUES
('7fdfd567-737e-4996-bdab-cc9fe67f3ad2', '02cada179d0de5eb5cf78f65d85e8ae86d2fc299297f5c1935c9454dfad74db3', '2025-12-18 23:28:27.049', '20251218232826_init', NULL, NULL, '2025-12-18 23:28:26.846', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Booking_userId_fkey` (`userId`),
  ADD KEY `Booking_facilityId_fkey` (`facilityId`);

--
-- Indexes for table `facility`
--
ALTER TABLE `facility`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Notification_userId_fkey` (`userId`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `User_email_key` (`email`),
  ADD UNIQUE KEY `User_nim_key` (`nim`);

--
-- Indexes for table `_prisma_migrations`
--
ALTER TABLE `_prisma_migrations`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `facility`
--
ALTER TABLE `facility`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `booking`
--
ALTER TABLE `booking`
  ADD CONSTRAINT `Booking_facilityId_fkey` FOREIGN KEY (`facilityId`) REFERENCES `facility` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `Booking_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `Notification_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
