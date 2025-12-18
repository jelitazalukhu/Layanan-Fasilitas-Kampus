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
  String selectedTab = "Ruang Kelas";
  final TextEditingController _searchController = TextEditingController();
  
  // Dummy Data Generators
  List<Map<String, dynamic>> get _ruangKelas => List.generate(5, (i) => {
    "nama": "Ruang ${widget.title} ${i + 1}",
    "status": "KOSONG",
    "jenis": "Ruang Kelas",
    "lantai": 2, // Dummy folder
  });

  List<Map<String, dynamic>> get _laboratorium => List.generate(3, (i) => {
    "nama": "Lab ${widget.title} ${String.fromCharCode(65 + i)}",
    "status": "KOSONG",
    "jenis": "Laboratorium",
  });

  List<Map<String, dynamic>> get _proyektor => List.generate(5, (i) => {
    "nama": "Proyektor ${i + 1}",
    "status": "TERSEDIA",
    "jenis": "Proyektor",
  });

  List<Map<String, dynamic>> get _dataTampil {
    if (selectedTab == "Ruang Kelas") return _ruangKelas;
    if (selectedTab == "Laboratorium") return _laboratorium;
    return _proyektor;
  }

  void _popupBooking(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (_) => BookingDialog(facilityName: item["nama"]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FFF4),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFFF1FFF4),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search Bar
          TextField(
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
          const SizedBox(height: 16),
          
          // Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["Ruang Kelas", "Laboratorium", "Proyektor"].map((tab) {
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
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Content
          if (selectedTab == "Proyektor")
             GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dataTampil.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) {
                final item = _dataTampil[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () => _popupBooking(item),
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.videocam, size: 40, color: Colors.green),
                        const SizedBox(height: 8),
                        Text(item["nama"], style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(item["status"], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            )
          else
            Column(
              children: _dataTampil.map((item) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      selectedTab == "Ruang Kelas" ? Icons.meeting_room : Icons.science,
                      size: 40, 
                      color: Colors.green
                    ),
                    title: Text(item["nama"], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item["status"], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    trailing: ElevatedButton(
                      onPressed: () => _popupBooking(item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF065F46),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Booking", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class BookingDialog extends StatefulWidget {
  final String facilityName;
  const BookingDialog({super.key, required this.facilityName});

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
    // Simulate booking delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Berhasil!"), backgroundColor: Colors.green),
    );
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
