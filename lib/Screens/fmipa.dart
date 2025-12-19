import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        "bookingStart": null,
        "bookingEnd": null,
      }
  ],
  2: [
    for (var l in ["A", "B", "C", "D", "E", "F"])
      {
        "nama": "Lab $l",
        "status": "KOSONG",
        "bookingStart": null,
        "bookingEnd": null,
      }
  ],
  3: [
    for (var l in ["A", "B", "C", "D", "E", "F"])
      {
        "nama": "Lab $l",
        "status": "KOSONG",
        "bookingStart": null,
        "bookingEnd": null,
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
        "bookingStart": null,
        "bookingEnd": null,
      }
  ],
  2: [
    for (int i = 1; i <= 9; i++)
      {
        "nama": "104.2.2.$i",
        "status": "KOSONG",
        "bookingStart": null,
        "bookingEnd": null,
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

  String sortBy = "nama_asc"; // A-Z / Z-A
  bool showOnlyKosong = false; // filter hanya kosong

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
            _sortBar(),
            const SizedBox(height: 8),
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
     SORT & FILTER BAR
     ====================== */

  Widget _sortBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        Row(
          children: [
            const Text("Hanya tersedia"),
            Switch(
              value: showOnlyKosong,
              onChanged: (v) {
                setState(() {
                  showOnlyKosong = v;
                });
              },
            ),
          ],
        ),
      ],
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

    // copy ke filtered
    var filtered = List<Map<String, dynamic>>.from(data);

    // filter hanya KOSONG
    if (showOnlyKosong) {
      filtered =
          filtered.where((e) => e["status"] == "KOSONG").toList();
    }

    // sorting
    filtered.sort((a, b) {
      final namaA = a["nama"].toString();
      final namaB = b["nama"].toString();

      if (sortBy == "nama_desc") {
        return namaB.compareTo(namaA); // Z-A
      }
      return namaA.compareTo(namaB); // A-Z
    });

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final d = filtered[i];

        // reset otomatis kalau waktu booking sudah lewat
        if (d['bookingEnd'] != null &&
            d['bookingEnd'] is DateTime &&
            DateTime.now().isAfter(d['bookingEnd'])) {
          d['status'] = "KOSONG";
          d['bookingStart'] = null;
          d['bookingEnd'] = null;
        }

        final bool kosong = d["status"] == "KOSONG";
        final Color statusColor =
            kosong ? Colors.green : Colors.red;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  d["status"],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed:
                      kosong ? () => _popupBooking(d) : null,
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
     POPUP BOOKING (LOCAL)
     ====================== */

  void _popupBooking(Map<String, dynamic> data) {
    DateTime selectedDate = DateTime.now();
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 11, minute: 0);
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) {
          Future<void> pickDate() async {
            final picked = await showDatePicker(
              context: ctx,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            );
            if (picked != null) {
              setStateDialog(() => selectedDate = picked);
            }
          }

          Future<void> pickTime(bool isStart) async {
            final picked = await showTimePicker(
              context: ctx,
              initialTime: isStart ? startTime : endTime,
            );
            if (picked != null) {
              setStateDialog(() {
                if (isStart) {
                  startTime = picked;
                } else {
                  endTime = picked;
                }
              });
            }
          }

          Future<void> doBooking() async {
            setStateDialog(() => isLoading = true);

            await Future.delayed(
                const Duration(milliseconds: 600)); // simulasi

            final start = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              startTime.hour,
              startTime.minute,
            );
            final end = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              endTime.hour,
              endTime.minute,
            );

            // update data lokal
            setState(() {
              data['bookingStart'] = start;
              data['bookingEnd'] = end;
              data['status'] = "TERISI";
            });

            setStateDialog(() => isLoading = false);
            if (!mounted) return;

            Navigator.pop(ctx);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Booking berhasil!"),
                backgroundColor: Colors.green,
              ),
            );
          }

          return AlertDialog(
            title: Text("Booking ${data["nama"]}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Tanggal"),
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(selectedDate),
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: pickDate,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text("Mulai"),
                        subtitle: Text(startTime.format(ctx)),
                        onTap: () => pickTime(true),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text("Selesai"),
                        subtitle: Text(endTime.format(ctx)),
                        onTap: () => pickTime(false),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : doBooking,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Booking"),
              ),
            ],
          );
        },
      ),
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
