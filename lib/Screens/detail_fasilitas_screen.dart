import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/facility_service.dart';

class DetailFasilitasScreen extends StatefulWidget {
  final String title;
  final dynamic facilityData;

  const DetailFasilitasScreen({super.key, required this.title, this.facilityData});

  @override
  State<DetailFasilitasScreen> createState() => _DetailFasilitasScreenState();
}

class _DetailFasilitasScreenState extends State<DetailFasilitasScreen> {
  String selectedTab = "";
  final TextEditingController _searchController = TextEditingController();
  
  // Static cache to persist data across screen navigation
  // Key: Facility Title -> Value: Map of Categories to List of Items
  static final Map<String, Map<String, List<Map<String, dynamic>>>> _globalCache = {};

  // Holds current facility data: { "Tab Name": [list of items] }
  late Map<String, List<Map<String, dynamic>>> _facilityData;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Check if data for this facility already exists in cache
    if (_globalCache.containsKey(widget.title)) {
      _facilityData = _globalCache[widget.title]!;
    } else {
      _facilityData = _generateDataForFacility(widget.title);
      _globalCache[widget.title] = _facilityData;
    }

    // Set initial selected tab to the first key
    if (_facilityData.isNotEmpty) {
      selectedTab = _facilityData.keys.first;
    }
  }

  Map<String, List<Map<String, dynamic>>> _generateDataForFacility(String title) {
    // 1. PERPUSTAKAAN
    if (title.toLowerCase().contains("perpustakaan")) {
      return {
        "Ruang Baca": List.generate(4, (i) => {
          "nama": "Ruang Baca ${String.fromCharCode(65 + i)}",
          "status": "BUKA",
          "jenis": "Ruang Baca",
        }),
        "Ruang Diskusi": List.generate(5, (i) => {
          "nama": "Ruang Diskusi ${i + 1}",
          "status": "KOSONG",
          "jenis": "Ruang Diskusi",
        }),
        "Ruang Konferensi": [
          {"nama": "Conference Room A", "status": "KOSONG", "jenis": "Ruang Konferensi"},
          {"nama": "Conference Room B", "status": "TERPAKAI", "jenis": "Ruang Konferensi"},
        ],
        "Bilik Baca Individu": List.generate(6, (i) => {
          "nama": "Rubelin ${i + 1}",
          "status": "TERSEDIA",
          "jenis": "Bilik Baca Individu",
        }),
      };
    }

    // 2. POLIKLINIK
    if (title.toLowerCase().contains("poliklinik")) {
      return {
        "Poli Umum": List.generate(3, (i) => {
          "nama": "Poli Umum ${i + 1}",
          "status": "BUKA",
          "jenis": "Poli Umum",
        }),
        "Poli Gigi": [
          {"nama": "Poli Gigi 1", "status": "BUKA", "jenis": "Poli Gigi"},
          {"nama": "Poli Gigi 2", "status": "ISTIRAHAT", "jenis": "Poli Gigi"},
        ],
        "Poli Spesialis": [
          {"nama": "Poli Mata", "status": "BUKA", "jenis": "Poli Spesialis"},
          {"nama": "Poli THT", "status": "BUKA", "jenis": "Poli Spesialis"},
        ],
        "Poli Konseling": [
          {"nama": "Ruang Konseling", "status": "TERSEDIA", "jenis": "Poli Konseling"},
        ],
      };
    }

    // 3. MASJID
    if (title.toLowerCase().contains("masjid")) {
      return {
        "Ruang Utama": [
          {"nama": "Shaf Utama Pria", "status": "TERBUKA", "jenis": "Ruang Utama"},
          {"nama": "Shaf Utama Wanita", "status": "TERBUKA", "jenis": "Ruang Utama"},
        ],
        "Aula Dakwah": [
          {"nama": "Aula Dakwah Utama", "status": "KOSONG", "jenis": "Aula Dakwah"},
        ],
      };
    }

    // 4. AUDITORIUM
    if (title.toLowerCase().contains("auditorium")) {
      return {
        "Main Hall": [
          {"nama": "Auditorium Main Hall", "status": "KOSONG", "jenis": "Main Hall"},
        ],
        "Ruang VIP": [
          {"nama": "Ruang Tunggu VIP", "status": "TERSEDIA", "jenis": "Ruang VIP"},
          {"nama": "Ruang Persiapan", "status": "KOSONG", "jenis": "Ruang VIP"},
        ],
      };
    }

    // 5. DEFAULT (FAKULTAS & LAINNYA)
    return {
      "Ruang Kelas": List.generate(6, (i) => {
        "nama": "Ruang Kelas ${title.replaceAll('Fakultas ', '')} ${i + 1}",
        "status": "KOSONG",
        "jenis": "Ruang Kelas", 
      }),
      "Laboratorium": List.generate(3, (i) => {
        "nama": "Lab ${title.replaceAll('Fakultas ', '')} ${String.fromCharCode(65 + i)}",
        "status": "KOSONG",
        "jenis": "Laboratorium",
      }),
    };
  }

  List<Map<String, dynamic>> get _dataTampil {
    if (selectedTab.isEmpty || !_facilityData.containsKey(selectedTab)) {
      return [];
    }
    return _facilityData[selectedTab]!;
  }

  Future<void> _popupBooking(Map<String, dynamic> item) async {
    final facilityId = widget.facilityData != null 
        ? widget.facilityData['id'] 
        : 0; // Fallback if no parent data

    final result = await showDialog(
      context: context,
      builder: (_) => BookingDialog(
        facilityName: item["nama"], 
        facilityId: facilityId
      ),
    );

    if (result == true) {
      if (mounted) {
        setState(() {
          item['status'] = 'TERPINJAM';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedTab.isEmpty && _facilityData.isNotEmpty) {
      selectedTab = _facilityData.keys.first;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF4),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFFF1FFF4),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Dynamic Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 16),
                ..._facilityData.keys.map((tab) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tab),
                      selected: selectedTab == tab,
                      onSelected: (val) {
                        if (val) setState(() => selectedTab = tab);
                      },
                      selectedColor: const Color(0xFF065F46),
                      labelStyle: TextStyle(
                        color: selectedTab == tab ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 16),
              ],
            ),
          ),
          
          const SizedBox(height: 16),

          // Content
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dataTampil.length,
              itemBuilder: (context, index) {
                final item = _dataTampil[index];
                
                // Customize Icon based on type
                IconData icon;
                if (item['jenis'].toString().contains("Poli")) icon = Icons.local_hospital;
                else if (item['jenis'].toString().contains("Baca")) icon = Icons.menu_book;
                else if (item['jenis'].toString().contains("Diskusi")) icon = Icons.groups;
                else if (item['jenis'].toString().contains("Masjid") || item['jenis'].toString().contains("Shaf")) icon = Icons.mosque;
                else if (item['jenis'].toString().contains("Dakwah")) icon = Icons.campaign;
                else if (item['jenis'].toString().contains("Hall")) icon = Icons.theater_comedy;
                else if (item['jenis'].toString().contains("Lab")) icon = Icons.science;
                else icon = Icons.meeting_room;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(icon, size: 40, color: Colors.green),
                    title: Text(item["nama"], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      item["status"], 
                      style: TextStyle(
                        color: (item["status"] == "TERPINJAM" || item["status"] == "TERPAKAI") ? Colors.red : Colors.green, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    trailing: ElevatedButton(
                      onPressed: (item["status"] == "TERPINJAM" || item["status"] == "TERPAKAI") ? null : () => _popupBooking(item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (item["status"] == "TERPINJAM" || item["status"] == "TERPAKAI") ? Colors.grey : const Color(0xFF065F46),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        (item["status"] == "TERPINJAM" || item["status"] == "TERPAKAI") ? "Dipinjam" : "Booking", 
                        style: const TextStyle(color: Colors.white)
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookingDialog extends StatefulWidget {
  final String facilityName; // This is the room name e.g. "Ruang 1"
  final int facilityId;      // This is the parent facility ID

  const BookingDialog({super.key, required this.facilityName, required this.facilityId});

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 11, minute: 0);
  bool _isLoading = false;

  Future<void> _doBooking() async {
    setState(() => _isLoading = true);

    try {
      final service = FacilityService();
      final result = await service.createBooking(
        widget.facilityId,
        _selectedDate,
        _startTime.hour,
        _endTime.hour,
        roomName: widget.facilityName
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (result['success']) {
        Navigator.pop(context, true); // Return true indicating success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booking Berhasil!"), backgroundColor: Colors.green),
        );
      } else {
        Navigator.pop(context, false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Booking Gagal"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
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
              "Booking ${widget.facilityName}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text("Tanggal"),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              trailing: const Icon(Icons.edit),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text("Mulai"),
                    subtitle: Text(_startTime.format(context)),
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: _startTime);
                      if (time != null) setState(() => _startTime = time);
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text("Selesai"),
                    subtitle: Text(_endTime.format(context)),
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: _endTime);
                      if (time != null) setState(() => _endTime = time);
                    },
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
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                : const Text("Konfirmasi Booking", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
