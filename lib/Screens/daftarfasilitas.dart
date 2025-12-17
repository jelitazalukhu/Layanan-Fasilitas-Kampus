import 'package:flutter/material.dart';

/* ======================
   DATA VOKASI
   ====================== */

final List<Map<String, dynamic>> vokasiRuangKelas = [
  for (int i = 201; i <= 207; i++)
    {
      "jenis": "Ruang Kelas",
      "nama": "RB$i",
      "lantai": 2,
      "status": i % 2 == 0 ? "TERISI" : "KOSONG",
      "gambar": "assets/usuu.jpg",
    },
  for (int i = 301; i <= 307; i++)
    {
      "jenis": "Ruang Kelas",
      "nama": "RB$i",
      "lantai": 3,
      "status": i % 2 == 0 ? "TERISI" : "KOSONG",
      "gambar": "assets/usuu.jpg",
    },
];

final List<Map<String, dynamic>> vokasiLab = [
  for (var lab in ["A", "B", "C", "D", "E"])
    {
      "jenis": "Laboratorium",
      "nama": "Lab $lab",
      "status": lab == "A" || lab == "C"
          ? "TERPAKAI"
          : "TIDAK TERPAKAI",
      "gambar": "assets/usuu.jpg",
    },
];

final List<Map<String, dynamic>> vokasiProyektor = [
  for (int i = 1; i <= 10; i++)
    {
      "jenis": "Proyektor",
      "nama": "Proyektor V${i.toString().padLeft(2, '0')}",
      "status": i % 3 == 0 ? "TERPAKAI" : "TERSEDIA",
    },
];

/* ======================
   SCREEN
   ====================== */

class FasilitasScreen extends StatefulWidget {
  const FasilitasScreen({super.key});

  @override
  State<FasilitasScreen> createState() => _HomePageState();
}

class _HomePageState extends State<FasilitasScreen> {
  String selectedKategori = "Fakultas";
  String selectedFakultas = "Fakultas Vokasi";

  String selectedVokasiBar = "Ruang Kelas";
  int? selectedLantai;

  List<Map<String, dynamic>> get vokasiDataTampil {
    if (selectedVokasiBar == "Ruang Kelas") {
      var data = vokasiRuangKelas;
      if (selectedLantai != null) {
        data = data.where((e) => e["lantai"] == selectedLantai).toList();
      }
      return data;
    }
    if (selectedVokasiBar == "Laboratorium") return vokasiLab;
    return vokasiProyektor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF4),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Fakultas Vokasi",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _barVokasi(),
          const SizedBox(height: 12),

          if (selectedVokasiBar == "Ruang Kelas") _dropdownLantai(),
          const SizedBox(height: 12),

          selectedVokasiBar == "Proyektor"
              ? _gridProyektor()
              : Column(
                  children:
                      vokasiDataTampil.map(_cardVokasi).toList(),
                ),
        ],
      ),
    );
  }

  /* ======================
     BAR VOKASI (TANPA SEMUA)
     ====================== */
  Widget _barVokasi() {
    final bar = ["Ruang Kelas", "Laboratorium", "Proyektor"];

    return Row(
      children: bar.map((b) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(b),
            selected: selectedVokasiBar == b,
            onSelected: (_) {
              setState(() {
                selectedVokasiBar = b;
                selectedLantai = null;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _dropdownLantai() {
    return DropdownButton<int?>(
      value: selectedLantai,
      hint: const Text("Pilih Lantai"),
      items: const [
        DropdownMenuItem(value: null, child: Text("Semua")),
        DropdownMenuItem(value: 2, child: Text("Lantai 2")),
        DropdownMenuItem(value: 3, child: Text("Lantai 3")),
      ],
      onChanged: (v) => setState(() => selectedLantai = v),
    );
  }

  /* ======================
     CARD RUANG & LAB
     ====================== */
  Widget _cardVokasi(Map<String, dynamic> data) {
    final aktif = data["status"] == "KOSONG" ||
        data["status"] == "TERSEDIA" ||
        data["status"] == "TIDAK TERPAKAI";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Image.asset(
            data["gambar"],
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          ListTile(
            title: Text(data["nama"],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(data["status"],
                style: TextStyle(
                    color: aktif ? Colors.green : Colors.red)),
            trailing: ElevatedButton(
              onPressed: aktif ? () => _popupBooking(data) : null,
              child: const Text("Booking"),
            ),
          ),
        ],
      ),
    );
  }

  /* ======================
     GRID PROYEKTOR
     ====================== */
  Widget _gridProyektor() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vokasiProyektor.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final p = vokasiProyektor[i];
        final aktif = p["status"] == "TERSEDIA";

        return GestureDetector(
          onTap: aktif ? () => _popupBooking(p) : null,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam,
                    size: 40,
                    color: aktif ? Colors.green : Colors.red),
                const SizedBox(height: 8),
                Text(p["nama"],
                    style:
                        const TextStyle(fontWeight: FontWeight.bold)),
                Text(p["status"]),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: aktif ? () => _popupBooking(p) : null,
                  child: const Text("Booking"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /* ======================
     POPUP BOOKING
     ====================== */
  void _popupBooking(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Booking ${data["nama"]}"),
        content: const Text(
          "Fitur booking akan dihubungkan ke backend.\n\n"
          "Status, jam, dan notifikasi masih placeholder.",
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Booking")),
        ],
      ),
    );
  }
}
