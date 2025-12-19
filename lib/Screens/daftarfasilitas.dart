import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/facility_service.dart';
import 'detail_fasilitas_screen.dart';
import 'vokasi.dart';
import 'fmipa.dart';

/// =====================
/// DAFTAR FAKULTAS (STATIS)
/// =====================

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

/// =====================
/// SCREEN
/// =====================

class DaftarFasilitasScreen extends StatefulWidget {
  final String? initialCategory;
  final String? initialFakultas;

  const DaftarFasilitasScreen({
    super.key,
    this.initialCategory,
    this.initialFakultas,
  });

  @override
  State<DaftarFasilitasScreen> createState() => _DaftarFasilitasScreenState();
}

class _DaftarFasilitasScreenState extends State<DaftarFasilitasScreen> {
  late String selectedKategori;
  String? selectedFakultas;

  final FacilityService _facilityService = FacilityService();
  late Future<List<dynamic>> _facilitiesFuture;

  @override
  void initState() {
    super.initState();
    selectedKategori = widget.initialCategory ?? "Semua";
    if (widget.initialFakultas != null) {
      selectedFakultas = widget.initialFakultas;
    }
    _facilitiesFuture = _facilityService.getFacilities();
  }

  bool isBuka(int? jamBuka, int? jamTutup) {
    if (jamBuka == null || jamTutup == null) return false;
    final now = DateTime.now().hour;
    return now >= jamBuka && now < jamTutup;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF1FFF4),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "CampusFind",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Universitas Sumatera Utara",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _facilitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final allFacilities = snapshot.data ?? [];

          // Filter Logic
          List<dynamic> dataTampil;
          if (selectedKategori == "Semua") {
            dataTampil = allFacilities;
          } else {
            dataTampil = allFacilities
                .where((f) => f['category'] == selectedKategori)
                .toList();
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _kategori(),
              const SizedBox(height: 16),

              // Kalau kategori = Fakultas → tampilkan grid fakultas lokal
              if (selectedKategori == "Fakultas") ...[
                _gridFakultas(),
              ] else ...[
                // Kategori lain → pakai data dari backend seperti biasa
                if (dataTampil.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: Text("Tidak ada fasilitas")),
                  ),
                ...dataTampil.map((data) => _cardFasilitas(data)).toList(),
              ],
            ],
          );
        },
      ),
    );
  }

  /// =====================
  /// WIDGET PENDUKUNG
  /// =====================

  Widget _kategori() {
    final kategori = ["Semua", "Fasilitas Umum", "Fakultas", "Masjid"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
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
      ),
    );
  }

  /// GRID SEMUA FAKULTAS
  /// Hanya Vokasi & FMIPA yang membuka screen khusus

  Widget _gridFakultas() {
    return SizedBox(
      height: 500, // bisa disesuaikan
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 16),
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
                  MaterialPageRoute(builder: (_) => const VokasiScreen()),
                );
              } else if (f["nama"] ==
                  "Fakultas Matematika dan Ilmu Pengetahuan Alam") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FmipaScreen()),
                );
              } else {
                setState(() => selectedFakultas = f["nama"]);
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
      ),
    );
  }

  Widget _cardFasilitas(dynamic data) {
    final buka = isBuka(data['openHour'], data['closeHour']);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailFasilitasScreen(
              title: data['name'],
              facilityData: data,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                data['imageUrl'] ?? 'assets/usu_logo.png', // Fallback
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(data['location'] ?? ""),
                  const SizedBox(height: 6),
                  Text(
                    buka
                        ? "BUKA (${data['openHour']}:00 - ${data['closeHour']}:00)"
                        : "TUTUP",
                    style: TextStyle(
                      color: buka ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['description'] ?? "",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =====================
/// BOOKING DIALOG
/// =====================

class BookingDialog extends StatefulWidget {
  final dynamic facility;
  const BookingDialog({super.key, required this.facility});

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 11, minute: 0);
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _doBooking() async {
    setState(() => _isLoading = true);

    // Convert TimeOfDay to int hour for backend (simplification)
    final startHour = _startTime.hour;
    final endHour = _endTime.hour;

    final service = FacilityService();
    final result = await service.createBooking(
      widget.facility['id'],
      _selectedDate,
      startHour,
      endHour,
    );

    print('BOOKING RESULT: $result'); 

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Booking Berhasil!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.calendar_today, size: 40, color: Colors.green),
            const SizedBox(height: 12),
            Text(
              "Booking ${widget.facility['name']}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Date Picker
            ListTile(
              title: const Text("Tanggal"),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              trailing: const Icon(Icons.edit),
              onTap: () => _selectDate(context),
            ),

            // Time Picker
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text("Mulai"),
                    subtitle: Text(_startTime.format(context)),
                    onTap: () => _selectTime(context, true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text("Selesai"),
                    subtitle: Text(_endTime.format(context)),
                    onTap: () => _selectTime(context, false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _doBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF065F46),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Konfirmasi Booking",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
