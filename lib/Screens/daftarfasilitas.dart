import 'package:flutter/material.dart';
import 'vokasi.dart'; // import file baru vokasi.dart

/* ======================
   DATA FASILITAS UMUM
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
];

/* ======================
   DAFTAR FAKULTAS
   ====================== */

final List<Map<String, String>> daftarFakultas = [
  {"nama": "Fakultas Ilmu Budaya"},
  {"nama": "Fakultas Ilmu Sosial dan Ilmu Politik"},
  {"nama": "Fakultas Keperawatan"},
  {"nama": "Fakultas Psikologi"},
  {"nama": "Fakultas Farmasi"},
  {"nama": "Fakultas Ilmu Komputer dan Teknologi Informasi"},
  {"nama": "Fakultas Kedokteran Gigi"},
  {"nama": "Fakultas Kesehatan Masyarakat"},
  {"nama": "Fakultas Pertanian"},
  {"nama": "Fakultas Hukum"},
  {"nama": "Fakultas Kedokteran"},
  {"nama": "Fakultas Teknik"},
  {"nama": "Fakultas Ekonomi dan Bisnis"},
  {"nama": "Fakultas Matematika dan Ilmu Pengetahuan Alam"},
  {"nama": "Fakultas Vokasi"},
];

/* ======================
   DATA FASILITAS PER FAKULTAS
   ====================== */

final Map<String, List<Map<String, dynamic>>> fasilitasFakultas = {
  "Fakultas Ilmu Budaya": [
    {
      "kategori": "Fakultas",
      "nama": "Ruang Kelas",
      "lokasi": "FIB USU",
      "gambar": "assets/usuu.jpg",
      "jamBuka": 7,
      "jamTutup": 18,
    },
  ],
  // ... fakultas lain (tetap sama, jangan diubah)
  "Fakultas Vokasi": [
    {
      "kategori": "Fakultas",
      "nama": "Laboratorium Praktik",
      "lokasi": "Vokasi USU",
      "gambar": "assets/usuu.jpg",
      "jamBuka": 8,
      "jamTutup": 17,
    },
    {
      "kategori": "Fakultas",
      "nama": "Ruang Kelas",
      "lokasi": "Vokasi USU",
      "gambar": "assets/usuu.jpg",
      "jamBuka": 7,
      "jamTutup": 18,
    },
  ],
};

/* ======================
   SCREEN
   ====================== */

class DaftarFasilitasScreen extends StatefulWidget {
  const DaftarFasilitasScreen({super.key});

  @override
  State<DaftarFasilitasScreen> createState() => _DaftarFasilitasScreenState();
}

class _DaftarFasilitasScreenState extends State<DaftarFasilitasScreen> {
  String selectedKategori = "Semua";
  String? selectedFakultas;

  bool isBuka(int jamBuka, int jamTutup) {
    final now = DateTime.now().hour;
    return now >= jamBuka && now < jamTutup;
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
            const Text(
              "Daftar Fasilitas Universitas Sumatera Utara",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _kategori(),
            const SizedBox(height: 16),

            if (selectedKategori == "Fakultas")
              selectedFakultas == null
                  ? _gridFakultas()
                  : _fasilitasFakultas(),

            if (selectedKategori != "Fakultas")
              ...dataTampil.map(_cardFasilitas).toList(),
          ],
        ),
      ),
    );
  }

  Widget _kategori() {
    final kategori = ["Semua", "Fasilitas Umum", "Fakultas", "Masjid"];
    return Row(
      children: kategori.map((k) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(k),
            selected: selectedKategori == k,
            onSelected: (_) {
              setState(() {
                selectedKategori = k;
                selectedFakultas = null;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _gridFakultas() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: daftarFakultas.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final f = daftarFakultas[index];
        return GestureDetector(
          onTap: () {
            if (f["nama"] == "Fakultas Vokasi") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VokasiScreen(),
                ),
              );
            } else {
              setState(() => selectedFakultas = f["nama"]);
            }
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_balance,
                      size: 36,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      f["nama"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _fasilitasFakultas() {
    final list = fasilitasFakultas[selectedFakultas] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() => selectedFakultas = null),
            ),
            Expanded(
              child: Text(
                selectedFakultas!,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 32),
            child: Center(
              child: Text("Belum ada data fasilitas",
                  style: TextStyle(color: Colors.grey)),
            ),
          )
        else
          ...list.map(_cardFasilitas).toList(),
      ],
    );
  }

  Widget _cardFasilitas(Map<String, dynamic> data) {
    final buka = isBuka(data["jamBuka"], data["jamTutup"]);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                Text(data["nama"],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(data["lokasi"] ?? ""),
                const SizedBox(height: 6),
                Text(buka ? "BUKA" : "TUTUP",
                    style: TextStyle(
                        color: buka ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
