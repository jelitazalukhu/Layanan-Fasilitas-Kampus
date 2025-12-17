import 'package:flutter/material.dart';

/* ======================
   DATA FASILITAS
   ====================== */

final List<Map<String, dynamic>> fasilitas = [
  {
    "kategori": "Fasilitas Umum",
    "nama": "Perpustakaan",
    "lokasi": "Kampus USU",
    "gambar": "assets/perpustakaan.jpeg",
    "fitur": ["WiFi Ready", "AC"],
    "jamBuka": 8,
    "jamTutup": 17,
  },
  {
    "kategori": "Fasilitas Umum",
    "nama": "Auditorium",
    "lokasi": "Kampus USU",
    "gambar": "assets/auditorium.webp",
    "fitur": ["Sound System", "AC"],
    "jamBuka": 8,
    "jamTutup": 22,
  },
  {
    "kategori": "Masjid",
    "nama": "Masjid Ar-Rahman",
    "lokasi": "Kampus USU",
    "gambar": "assets/masjid_ar-rahman.jpg",
    "fitur": ["Tempat Wudhu", "AC"],
    "jamBuka": 0,
    "jamTutup": 24, // 24 jam
  },
];

/* ======================
   HOME PAGE
   ====================== */

class FasilitasScreen extends StatefulWidget {
  const FasilitasScreen({super.key});

  @override
  State<FasilitasScreen> createState() => _HomePageState();
}

class _HomePageState extends State<FasilitasScreen> {
  String selectedKategori = "Semua";

  /* ======================
     FUNGSI STATUS BUKA
     ====================== */

  bool isBuka(int jamBuka, int jamTutup) {
    final now = DateTime.now().hour;
    return now >= jamBuka && now < jamTutup;
  }

  String keteranganJam(int jamBuka, int jamTutup) {
    if (jamBuka == 0 && jamTutup == 24) {
      return "Buka 24 Jam";
    }
    return "Jam Operasional "
        "${jamBuka.toString().padLeft(2, '0')}.00 - "
        "${jamTutup.toString().padLeft(2, '0')}.00";
  }

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
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage("assets/usuu.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(24),
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
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
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
    final buka = isBuka(data["jamBuka"], data["jamTutup"]);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              data["gambar"],
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
                const SizedBox(height: 8),

                // STATUS BUKA / TUTUP
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: buka ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      buka ? "BUKA" : "TUTUP",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: buka ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  keteranganJam(data["jamBuka"], data["jamTutup"]),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 12),

                // FITUR
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
