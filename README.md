# CampusFind

Projek Akhir Mata Kuliah Pemrograman Mobile Kelompok 7

## Kelompok 7 :<br>
1. Jelita Crisna Zalukhu (241712022)
2. Maulia Revani Putri (241712009)
3. Yatra Sima Kaputra (2312712119)
4. Argya Ariella (241712028)
5. William Tanu Wijaya (241712036)

## Deskripsi Singkat Aplikasi<br>
CampusFind  adalah aplikasi mobile berbasis Flutter yang dirancang untuk memudahkan mahasiswa dalam mengakses informasi terkait fasilitas kampus secara cepat dan akurat. Aplikasi ini menyediakan daftar fasilitas lengkap, termasuk fasilitas umum, fakultas, beserta detail seperti lokasi dan gambar visual pendukung. Dengan antarmuka yang interaktif dan responsif, pengguna dapat menavigasi dan menemukan informasi fasilitas dengan mudah, mendukung efisiensi kegiatan sehari-hari di lingkungan kampus, serta meningkatkan pengalaman pengguna dalam memanfaatkan layanan yang tersedia.

## Daftar Fitur
1. Home Dashboard: Menampilkan ringkasan fasilitas utama, pengumuman, dan navigasi cepat ke fitur lainnya.<br>
2. Daftar Fasilitas: Menyediakan daftar fasilitas kampus lengkap, termasuk kategori seperti Fakultas, Kantin, Masjid, dan Lainnya.<br>
3. Detail Fasilitas: Menampilkan informasi detail tiap fasilitas, termasuk:<br>
   - Lokasi fasilitas<br>
   - Jam operasional<br>
   - Fitur yang tersedia (WiFi, AC, parkir, dll.)<br>
   - Kontak pengelola<br>
   - Link ke Google Maps untuk navigasi<br>
4. Peta Kampus: Menyediakan peta interaktif kampus untuk memudahkan navigasi ke fasilitas yang dipilih.<br>
5. Pencarian Fasilitas: Fitur pencarian untuk menemukan fasilitas berdasarkan nama atau kategori.<br>
6. Status Fasilitas: Menunjukkan ketersediaan fasilitas secara real-time (misal: buka/tutup, penuh/tersedia).<br>
7. Login & Register: Pengguna dapat membuat akun baru dan login untuk mengakses fitur personalisasi.<br>
8. Profil Pengguna: Menampilkan informasi pengguna, pengaturan akun, dan preferensi aplikasi.<br>

## Technical Stack Application
- **Flutter:** 3.13.0
- **Dart SDK:** 3.9.0
- **State Management:** Provider 6.1.2  
- **UI & Icons:**  
  - Cupertino Icons 1.0.8  
  - Poppins Font (Regular, Medium 500, SemiBold 600, Bold 700)  
- **Dev Tools & Linting:**  
  - Flutter Test (builtin)  
  - Flutter Lints 5.0.0  
- **Assets:**  
  - Images: `usu_logo.png`, `usuu.jpg`, `fakultas.jpg`, `masjid.jpg`, `perpus.jpg`, `poli.jpg`, `kantin.jpg`, `peta.jpg`, `kampus_usu.jpg`, `fakultas-ilmu-budaya.webp`, `auditorium.webp`, `masjid_ar-rahman.jpg`, `perpustakaan.jpeg`  
- **Design & Layout:** Material Design (Flutter built-in)  
- **Platform yang didukung:** Android & iOS

## Cara Menjalankan Aplikasi
Panduan berikut menjelaskan langkah-langkah menjalankan aplikasi **CampusFind**.
1. **Clone repository**  
   Salin project dari GitHub ke komputer:
   ```bash
   git clone https://github.com/jelitazalukhu/Layanan-Fasilitas-Kampus.git
2. **Masuk ke folder project**
   Pindah ke direktori project:
   ```bash
   cd Layanan-Fasilitas-Kampus
4. **Install dependencies**
   Install semua package yang diperlukan aplikasi:
   ```bash
   flutter pub get
4. **Cek device atau emulator**
   Pastikan tersedia device untuk menjalankan aplikasi:
   ```bash
   flutter devices
   ```
   Bisa menggunakan emulator Android/iOS atau perangkat fisik yang terhubung.
5. **Jalankan aplikasi**
   Jalankan aplikasi pada device yang tersedia:
   ```bash
   flutter run
7. **Mode release (opsional)**
   Untuk versi final yang lebih cepat dan siap digunakan:
   ```bash
   flutter run --release
8. Troubleshooting
   Jika terjadi error dependency:
   ```bash
   flutter clean
   flutter pub get
   ```
   Jika Flutter tidak dikenali, pastikan Flutter sudah terinstall dan PATH telah dikonfigurasi.
   Jika device tidak muncul, periksa emulator atau pastikan perangkat fisik berada dalam mode developer.


