import 'package:flutter/material.dart';

/* ======================
   DATA FMIPA
   ====================== */

final List<String> unitBar = [
  "Unit 1",
  "Unit 2",
  "Unit 3",
  "Unit 4",
  "Unit 5",
];

/* ---------- UNIT 2 ---------- */

final Map<int, List<Map<String, dynamic>>> unit2Lab = {
  1: [
    for (var l in ["A", "B", "C", "D", "E", "F"])
      {
        "nama": "Lab $l",
        "status": "KOSONG",
      }
  ],
  2: [
    for (var l in ["A", "B", "C", "D", "E", "F"])
      {
        "nama": "Lab $l",
        "status": "KOSONG",
      }
  ],
  3: [
    for (var l in ["A", "B", "C", "D", "E", "F"])
      {
        "nama": "Lab $l",
        "status": "KOSONG",
      }
  ],
};

/* ---------- UNIT 4 ---------- */

final Map<int, List<Map<String, dynamic>>> unit4Ruangan = {
  1: [
    for (int i = 1; i <= 9; i++)
      {
        "nama": "104.1.1.$i",
        "status": "KOSONG",
      }
  ],
  2: [
    for (int i = 1; i <= 9; i++)
      {
        "nama": "104.2.2.$i",
        "status": "KOSONG",
      }
  ],
};

/* ======================
   SCREEN FMIPA
   ====================== */

class FmipaScreen extends StatefulWidget {
  const FmipaScreen({super.key});

  @override
  State<FmipaScreen> createState() => _FmipaScreenState();
}

class _FmipaScreenState extends State<FmipaScreen> {
  String selectedUnit = "Unit 2";
  int selectedLantai = 1;

  bool get unitTersedia =>
      selectedUnit == "Unit 2" || selectedUnit == "Unit 4";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF4),
      appBar: AppBar(
        title: const Text("FMIPA USU"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _unitBar(),
          const SizedBox(height: 12),

          if (unitTersedia) ...[
            _dropdownLantai(),
            const SizedBox(height: 16),
            _gridIsi(),
          ] else
            _belumTersedia(),
        ],
      ),
    );
  }

  /* ======================
     UNIT BAR
     ====================== */

  Widget _unitBar() {
    return Wrap(
      spacing: 8,
      children: unitBar.map((u) {
        return ChoiceChip(
          label: Text(u),
          selected: selectedUnit == u,
          onSelected: (_) {
            setState(() {
              selectedUnit = u;
              selectedLantai = 1;
            });
          },
        );
      }).toList(),
    );
  }

  /* ======================
     DROPDOWN LANTAI
     ====================== */

  Widget _dropdownLantai() {
    final lantaiList =
        selectedUnit == "Unit 2" ? [1, 2, 3] : [1, 2];

    return DropdownButton<int>(
      value: selectedLantai,
      items: lantaiList
          .map(
            (l) => DropdownMenuItem(
              value: l,
              child: Text("Lantai $l"),
            ),
          )
          .toList(),
      onChanged: (v) => setState(() => selectedLantai = v!),
    );
  }

  /* ======================
     GRID ISI
     ====================== */

  Widget _gridIsi() {
    final List<Map<String, dynamic>> data =
        selectedUnit == "Unit 2"
            ? unit2Lab[selectedLantai]!
            : unit4Ruangan[selectedLantai]!;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final d = data[i];

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selectedUnit == "Unit 2"
                      ? Icons.science
                      : Icons.meeting_room,
                  size: 40,
                  color: Colors.green,
                ),
                const SizedBox(height: 8),
                Text(
                  d["nama"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  "KOSONG",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Booking"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /* ======================
     BELUM TERSEDIA
     ====================== */

  Widget _belumTersedia() {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: const [
          Icon(Icons.info_outline, size: 48, color: Colors.orange),
          SizedBox(height: 12),
          Text(
            "Fasilitas Belum Tersedia",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Data untuk unit ini belum tersedia saat ini.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
