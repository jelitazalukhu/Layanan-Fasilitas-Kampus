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
      "status": "KOSONG",
      "gambar": "assets/usuu.jpg",
    },
  for (int i = 301; i <= 307; i++)
    {
      "jenis": "Ruang Kelas",
      "nama": "RB$i",
      "lantai": 3,
      "status": "KOSONG",
      "gambar": "assets/usuu.jpg",
    },
];

final List<Map<String, dynamic>> vokasiLab = [
  for (var lab in ["A", "B", "C", "D", "E"])
    {
      "jenis": "Laboratorium",
      "nama": "Lab $lab",
      "status": "KOSONG",
      "gambar": "assets/usuu.jpg",
    },
];

final List<Map<String, dynamic>> vokasiProyektor = [
  for (int i = 1; i <= 10; i++)
    {
      "jenis": "Proyektor",
      "nama": "Proyektor V${i.toString().padLeft(2, '0')}",
      "status": "TERSEDIA",
    },
];

/* ======================
   SCREEN VOKASI
   ====================== */

class VokasiScreen extends StatefulWidget {
  const VokasiScreen({super.key});

  @override
  State<VokasiScreen> createState() => _VokasiScreenState();
}

class _VokasiScreenState extends State<VokasiScreen> {
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

  void _popupBooking(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Booking ${data["nama"]}"),
        content: const Text(
          "Booking jam dan durasi akan muncul di sini.\n"
          "Status masih placeholder.\n"
          "Peringatan 30 menit sebelum habis.",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF4),
      appBar: AppBar(title: const Text("Fakultas Vokasi")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _barVokasi(),
          const SizedBox(height: 12),
          if (selectedVokasiBar == "Ruang Kelas") _dropdownLantai(),
          const SizedBox(height: 12),
          selectedVokasiBar == "Proyektor"
              ? _gridProyektor()
              : Column(children: vokasiDataTampil.map(_cardVokasi).toList()),
        ],
      ),
    );
  }

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

  Widget _cardVokasi(Map<String, dynamic> data) {
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
                style: const TextStyle(color: Colors.green)),
            trailing: ElevatedButton(
              onPressed: () => _popupBooking(data),
              child: const Text("Booking"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridProyektor() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vokasiProyektor.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final p = vokasiProyektor[i];
        return GestureDetector(
          onTap: () => _popupBooking(p),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam, size: 40, color: Colors.green),
                const SizedBox(height: 8),
                Text(p["nama"], style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(p["status"]),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _popupBooking(p),
                  child: const Text("Booking"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
