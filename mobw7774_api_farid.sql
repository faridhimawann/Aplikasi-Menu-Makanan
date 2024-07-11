-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 11 Jul 2024 pada 16.21
-- Versi server: 10.3.39-MariaDB-cll-lve
-- Versi PHP: 8.1.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mobw7774_api_farid`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

CREATE TABLE `categories` (
  `id` int(6) UNSIGNED NOT NULL,
  `category_name` varchar(50) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`id`, `category_name`, `description`) VALUES
(1, 'Makanan Berat', 'makanan berat'),
(3, 'Minuman', 'Minuman'),
(6, 'Makanan Tradisional', 'Makanan Tradisioal'),
(7, 'Makanan Sehat', 'Makanan Sehat');

-- --------------------------------------------------------

--
-- Struktur dari tabel `favorites`
--

CREATE TABLE `favorites` (
  `id` int(11) NOT NULL,
  `recipe_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `favorites`
--

INSERT INTO `favorites` (`id`, `recipe_id`) VALUES
(3, 2),
(4, 4),
(5, 5),
(6, 6);

-- --------------------------------------------------------

--
-- Struktur dari tabel `receipts`
--

CREATE TABLE `receipts` (
  `id` int(6) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `category_id` int(6) UNSIGNED DEFAULT NULL,
  `image` varchar(255) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `receipts`
--

INSERT INTO `receipts` (`id`, `name`, `category_id`, `image`, `description`) VALUES
(1, 'Nasi Goreng', 1, 'foto/1000000033.jpg', ''),
(2, 'Kwetiau Goreng', 1, 'foto/kwetiaw.jpg', '300 gram kwetiau basah, dicuci bersih 2 siung bawang putih, dicincang kasar 1/2 buah bawang bombai, diiris panjang 1 butir telur, dikocok lepas 3 batang caisim, dipotong-potong 1 sendok teh garam 1/4 sendok teh merica bubuk 1 batang daun bawang, diiris miring 50 ml air 1 sendok makan minyak untuk menumis'),
(3, 'Nasi Goreng Seafood', 1, 'foto/1000000033.jpg', ''),
(4, 'Es Jeruk', 3, 'foto/es jeruk.jpg', '2 buah jeruk peras\n1 sdm gula pasir (selera manisnya)\n3 sdm air panas(untuk melarutkan gula)\nSecukupnya es batu'),
(6, 'Soto Betawi', 6, 'foto/soto betawi.jpg', '500 g daging sapi has dalam bagian sandung lamur, potong-potong\n200 g babat sapi, rebus, potong 2x2cm\n200 g paru sapi, rebus, potong 2x2cm\n3 sdm Bango kecap manis\n3 cm kayumanis\n1 sdt pala bubuk\n4 buah cengkeh utuh\n3 buah batang serai, memarkan\n5 buah daun jeruk, buang tulang, iris memanjang\n2 cm lengkuas, memarkan\n4 sdt garam\n2 lembar daun salam\n1 sdt gula pasir\n1/2 sdt merica bubuk\n500 ml santan dari 1 butir kelapa\n2 sdm minyak\n2 l air');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(6) UNSIGNED NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'admin', 'admin');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `receipts`
--
ALTER TABLE `receipts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`) USING BTREE;

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `receipts`
--
ALTER TABLE `receipts`
  MODIFY `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `receipts`
--
ALTER TABLE `receipts`
  ADD CONSTRAINT `receipts_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
