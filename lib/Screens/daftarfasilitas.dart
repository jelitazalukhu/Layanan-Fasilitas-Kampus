import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/* ======================
   DATA FASILITAS
   ====================== */

final List<Map<String, dynamic>> fasilitas = [
  {
    "kategori": "Fasilitas Umum",
    "nama": "Perpustakaan",
    "lokasi": "Kampus USU",
    "gambar": "assets/images/perpustakaan.jpeg",
    "fitur": ["WiFi Ready", "AC"],
  },
  {
    "kategori": "Fasilitas Umum",
    "nama": "Auditorium",
    "lokasi": "Kampus USU",
    "gambar": "assets/images/auditorium.webp",
    "fitur": ["Sound System", "AC"],
  },
  {
    "kategori": "Masjid",
    "nama": "Masjid Ar-Rahman",
    "lokasi": "Kampus USU",
    "gambar": "assets/images/masjid_ar-rahman.jpg",
    "fitur": ["Tempat Wudhu", "AC"],
  },
];

/* ======================
   APP
   ====================== */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Fasilitas',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

/* ======================
   HOME PAGE
   ====================== */

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedKategori = "Semua";

  @override
  Widget build(BuildContext context) {
    final dataTampil = selectedKategori == "Semua"
        ? fasilitas
        : fasilitas.where((f) => f["kategori"] == selectedKategori).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF4),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _header(),
            const SizedBox(height: 16),
            _searchBar(),
            const SizedBox(height: 16),
            _kategori(),
            const SizedBox(height: 16),
            ...dataTampil.map(_cardFasilitas).toList(),
          ],
        ),
      ),
    );
  }

  /* ======================
     WIDGET
     ====================== */

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Daftar Fasilitas",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Kampus Universitas Sumatera Utara",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Cari fasilitas...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _kategori() {
    final kategori = ["Semua", "Fasilitas Umum", "Fakultas", "Masjid"];

    return Row(
      children: kategori.map((k) {
        final aktif = selectedKategori == k;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(k),
            selected: aktif,
            onSelected: (_) {
              setState(() => selectedKategori = k);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _cardFasilitas(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              data["gambar"], // ⚠️ TANPA assets/
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["nama"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(data["lokasi"]),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: (data["fitur"] as List<String>)
                      .map((f) => Chip(label: Text(f)))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
