# CampusFind

## Kelompok 7 :<br>
1. Jelita Crisna Zalukhu (241712022)
2. Maulia Revani Putri (241712009)
3. Yatra Sima Kaputra (231712119)
4. Argya Ariella (241712028)
5. William Tanu Wijaya (241712036)

## Deskripsi Singkat Aplikasi<br>
CampusFind  adalah aplikasi mobile berbasis Flutter yang dirancang untuk memudahkan mahasiswa dalam mengakses informasi terkait fasilitas kampus secara cepat dan akurat. Aplikasi ini menyediakan daftar fasilitas lengkap, termasuk fasilitas umum, fakultas, beserta detail seperti lokasi dan gambar visual pendukung. Dengan antarmuka yang interaktif dan responsif, pengguna dapat menavigasi dan menemukan informasi fasilitas dengan mudah, mendukung efisiensi kegiatan sehari-hari di lingkungan kampus, serta meningkatkan pengalaman pengguna dalam memanfaatkan layanan yang tersedia.


## Fitur

* Booking fasilitas Fakultas Vokasi (Ruang Kelas, Laboratorium, Proyektor) dengan pemilihan tanggal dan jam.
* Booking fasilitas FMIPA (Unit 2 dan Unit 4) dengan pilihan lantai dan ruangan/lab.
* Filter fasilitas berdasarkan nama, jenis, lantai, dan status ketersediaan.
* Sorting daftar fasilitas (Nama A–Z dan Z–A).
* Toggle “Hanya kosong” untuk menampilkan hanya fasilitas yang tersedia.
* Status fasilitas dinamis (KOSONG, TERISI, TERSEDIA, TERPAKAI) dengan reset otomatis setelah waktu booking berakhir (level UI).

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
- **Platform yang didukung:** Android


## How to Run Application

### 1. Persyaratan Sistem

- Flutter SDK terinstal (versi sesuai yang digunakan di proyek).
- Dart SDK (biasanya sudah termasuk di Flutter).
- Android Studio atau VS Code dengan ekstensi Flutter.
- Emulator atau perangkat fisik Android untuk pengujian.
- Git (opsional, jika clone dari repository).

### 2. Menjalankan Aplikasi Flutter
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



