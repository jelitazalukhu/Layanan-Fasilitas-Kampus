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

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  // SORT & FILTER
  String sortBy = "nama_asc"; // "nama_asc" atau "nama_desc"
  bool showOnlyKosong = false;

  List<Map<String, dynamic>> get vokasiDataTampil {
    List<Map<String, dynamic>> data;

    if (selectedVokasiBar == "Ruang Kelas") {
      data = List<Map<String, dynamic>>.from(vokasiRuangKelas);
      if (selectedLantai != null) {
        data = data.where((e) => e["lantai"] == selectedLantai).toList();
      }
    } else if (selectedVokasiBar == "Laboratorium") {
      data = List<Map<String, dynamic>>.from(vokasiLab);
    } else {
      data = List<Map<String, dynamic>>.from(vokasiProyektor);
    }

    // filter search
    if (searchQuery.isNotEmpty) {
      data = data
          .where((e) => e["nama"]
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    }

    // filter hanya yang KOSONG
    if (showOnlyKosong) {
      data = data.where((e) => e["status"] == "KOSONG").toList();
    }

    // sorting Nama A-Z / Z-A
    data.sort((a, b) {
      final namaA = a["nama"].toString();
      final namaB = b["nama"].toString();

      if (sortBy == "nama_desc") {
        return namaB.compareTo(namaA); // Z-A
      }
      // default: A-Z
      return namaA.compareTo(namaB);
    });

    return data;
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
            child: const Text("Tutup"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Booking"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF4),
      appBar: AppBar(
        title: const Text("Fakultas Vokasi"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _searchBar(),
          const SizedBox(height: 12),
          _barVokasi(),
          const SizedBox(height: 12),
          _sortFilterBar(),
          const SizedBox(height: 12),
          if (selectedVokasiBar == "Ruang Kelas") _dropdownLantai(),
          const SizedBox(height: 12),
          selectedVokasiBar == "Proyektor"
              ? _gridProyektor()
              : Column(
                  children: vokasiDataTampil.map(_cardVokasi).toList(),
                ),
        ],
      ),
    );
  }

  /* ======================
     SEARCH BAR
     ====================== */

  Widget _searchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: "Cari ruang / lab / proyektor...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        setState(() => searchQuery = value);
      },
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
                searchQuery = "";
                _searchController.clear();
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _sortFilterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Dropdown sort
        DropdownButton<String>(
          value: sortBy,
          items: const [
            DropdownMenuItem(
              value: "nama_asc",
              child: Text("Urutkan: Nama A-Z"),
            ),
            DropdownMenuItem(
              value: "nama_desc",
              child: Text("Urutkan: Nama Z-A"),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              sortBy = value;
            });
          },
        ),

        // Toggle hanya yang kosong
        Row(
          children: [
            const Text("Hanya kosong"),
            Switch(
              value: showOnlyKosong,
              onChanged: (value) {
                setState(() {
                  showOnlyKosong = value;
                });
              },
            ),
          ],
        ),
      ],
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
     CARD RUANG & LAB (ICON)
     ====================== */

  Widget _cardVokasi(Map<String, dynamic> data) {
    final bool isRuangKelas = data["jenis"] == "Ruang Kelas";
    final bool isLab = data["jenis"] == "Laboratorium";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              isRuangKelas
                  ? Icons.meeting_room
                  : isLab
                      ? Icons.science
                      : Icons.category,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            Text(
              data["nama"],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              data["status"],
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _popupBooking(data),
                child: const Text("Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ======================
     GRID PROYEKTOR (ASLI)
     ====================== */

  Widget _gridProyektor() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vokasiDataTampil.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final p = vokasiDataTampil[i];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.videocam, size: 40, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                p["nama"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(p["status"]),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _popupBooking(p),
                child: const Text("Booking"),
              ),
            ],
          ),
        );
      },
    );
  }
}
