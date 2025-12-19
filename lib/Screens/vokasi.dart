import 'package:flutter/material.dart';
import '../services/facility_service.dart';
import 'package:intl/intl.dart';

/* ======================
   DATA VOKASI
   ====================== */

final List<Map<String, dynamic>> vokasiRuangKelas = [
  for (int i = 201; i <= 207; i++)
    {
      "facilityId": 2, // id facility di tabel `facility`
      "jenis": "Ruang Kelas",
      "nama": "RB$i",
      "lantai": 2,
      "status": "KOSONG",
      "gambar": "assets/usuu.jpg",
      "bookingStart": null,
      "bookingEnd": null,
    },
  for (int i = 301; i <= 307; i++)
    {
      "facilityId": 2,
      "jenis": "Ruang Kelas",
      "nama": "RB$i",
      "lantai": 3,
      "status": "KOSONG",
      "gambar": "assets/usuu.jpg",
      "bookingStart": null,
      "bookingEnd": null,
    },
];

final List<Map<String, dynamic>> vokasiLab = [
  for (var lab in ["A", "B", "C", "D", "E"])
    {
      "facilityId": 2,
      "jenis": "Laboratorium",
      "nama": "Lab $lab",
      "status": "KOSONG",
      "gambar": "assets/usuu.jpg",
      "bookingStart": null,
      "bookingEnd": null,
    },
];

final List<Map<String, dynamic>> vokasiProyektor = [
  for (int i = 1; i <= 10; i++)
    {
      "facilityId": 2,
      "jenis": "Proyektor",
      "nama": "Proyektor V${i.toString().padLeft(2, '0')}",
      "status": "TERSEDIA",
      "bookingStart": null,
      "bookingEnd": null,
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

    // filter hanya yang "kosong"/available
    if (showOnlyKosong) {
      data = data.where((e) {
        final status = e["status"]?.toString().toUpperCase() ?? "";
        // ruang/lab dianggap kosong jika "KOSONG"
        // proyektor dianggap kosong jika "TERSEDIA"
        return status == "KOSONG" || status == "TERSEDIA";
      }).toList();
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

  // ==== POPUP BOOKING (PAKAI BACKEND) ====

  void _popupBooking(Map<String, dynamic> data) {
    final service = FacilityService();
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

            final facilityId = data['facilityId'] as int;

            final result = await service.createBooking(
              facilityId,
              selectedDate,
              startTime.hour,
              endTime.hour,
            );

            setStateDialog(() => isLoading = false);
            if (!mounted) return;

            if (result['success']) {
              // simpan waktu booking di item yg ditekan
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

              if (data["jenis"] == "Proyektor") {
                // semua proyektor ikut terpakai
                setState(() {
                  for (final proj in vokasiProyektor) {
                    proj['bookingStart'] = start;
                    proj['bookingEnd'] = end;
                    proj['status'] = "TERPAKAI";
                  }
                });
              } else {
                // ruang / lab: hanya item ini
                data['bookingStart'] = start;
                data['bookingEnd'] = end;
                data["status"] = "TERISI";
                setState(() {});
              }
            }

            Navigator.pop(ctx);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['success']
                    ? "Booking berhasil!"
                    : (result['message'] ?? "Booking gagal")),
                backgroundColor:
                    result['success'] ? Colors.green : Colors.red,
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
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
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
     CARD RUANG & LAB
     ====================== */

  Widget _cardVokasi(Map<String, dynamic> data) {
    final bool isRuangKelas = data["jenis"] == "Ruang Kelas";
    final bool isLab = data["jenis"] == "Laboratorium";

    // reset otomatis kalau waktu booking sudah lewat
    if (data['bookingEnd'] != null &&
        data['bookingEnd'] is DateTime &&
        DateTime.now().isAfter(data['bookingEnd'])) {
      data['status'] = data["jenis"] == "Proyektor" ? "TERSEDIA" : "KOSONG";
      data['bookingStart'] = null;
      data['bookingEnd'] = null;
    }

    // warna status
    Color statusColor;
    final status = data["status"]?.toString().toUpperCase() ?? "";
    if (status == "KOSONG" || status == "TERSEDIA") {
      statusColor = Colors.green;
    } else {
      statusColor = Colors.red;
    }

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
              style: TextStyle(
                color: statusColor,
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
     GRID PROYEKTOR
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

        // reset otomatis kalau waktu booking sudah lewat
        if (p['bookingEnd'] != null &&
            p['bookingEnd'] is DateTime &&
            DateTime.now().isAfter(p['bookingEnd'])) {
          p['status'] = "TERSEDIA";
          p['bookingStart'] = null;
          p['bookingEnd'] = null;
        }

        final status = p["status"]?.toString().toUpperCase() ?? "";
        final Color statusColor =
            (status == "TERSEDIA") ? Colors.green : Colors.red;

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
              Text(
                p["status"],
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: status == "TERSEDIA" ? () => _popupBooking(p) : null,
                child: const Text("Booking"),
              ),
            ],
          ),
        );
      },
    );
  }
}
