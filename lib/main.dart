import 'package:flutter/material.dart';

void main() {
  runApp(const SmartCampusApp());
}

class SmartCampusApp extends StatelessWidget {
  const SmartCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

// -----------------------------------------------------------------------------
// MODEL DATA
// -----------------------------------------------------------------------------
class Facility {
  final String title;
  final String description;
  final String category;
  final bool isAvailable;
  final String capacity;
  final String location;
  final List<String> features;

  Facility({
    required this.title,
    required this.description,
    required this.category,
    required this.isAvailable,
    required this.capacity,
    required this.location,
    required this.features,
  });
}

// -----------------------------------------------------------------------------
// HALAMAN UTAMA
// -----------------------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Facility> facilities = [
      Facility(
        title: "Lab Komputer B201",
        description: "Lab komputer dengan 30 unit PC",
        category: "Lab",
        isAvailable: true,
        capacity: "30 orang",
        location: "Gedung B, Lantai 2",
        features: ["30 PC i5", "Proyektor", "AC", "+1 lainnya"],
      ),
      Facility(
        title: "Ruang Kuliah A301",
        description: "Ruang kuliah dengan proyektor dan AC",
        category: "Kelas",
        isAvailable: false,
        capacity: "50 orang",
        location: "Gedung A, Lantai 3",
        features: ["Proyektor", "AC"],
      ),
      Facility(
        title: "Ruang Kuliah A302",
        description: "Ruang kelas kapasitas 40 orang",
        category: "Kelas",
        isAvailable: true,
        capacity: "40 orang",
        location: "Gedung A, Lantai 3",
        features: ["AC"],
      ),
      Facility(
        title: "Laboratorium Elektronika",
        description: "Lab untuk praktikum rangkaian",
        category: "Lab",
        isAvailable: true,
        capacity: "25 orang",
        location: "Gedung C, Lantai 1",
        features: ["Alat ukur", "AC"],
      ),
      Facility(
        title: "Lapangan Basket",
        description: "Lapangan outdoor kampus",
        category: "Olahraga",
        isAvailable: false,
        capacity: "10 orang",
        location: "Area Sport Center",
        features: ["Outdoor"],
      ),
      Facility(
        title: "Ruang Gym",
        description: "Gym dengan peralatan lengkap",
        category: "Olahraga",
        isAvailable: true,
        capacity: "20 orang",
        location: "Sport Center Lt. 1",
        features: ["Treadmill", "Dumbell", "AC"],
      ),
      Facility(
        title: "Proyektor Epson X200",
        description: "Peralatan multimedia untuk presentasi",
        category: "Equipment",
        isAvailable: true,
        capacity: "-",
        location: "Ruang Multimedia",
        features: ["HDMI", "Remote"],
      ),
      Facility(
        title: "Kamera DSLR Canon",
        description: "Kamera untuk dokumentasi kegiatan",
        category: "Equipment",
        isAvailable: false,
        capacity: "-",
        location: "Ruang Dokumentasi",
        features: ["Lensa Kit"],
      ),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Browse"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Booking"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifikasi",
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 45, 20, 25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0072FF), Color(0xFF00C6A7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Smart Campus",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Sistem Booking Fasilitas Kampus",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Cari fasilitas...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      FilterChipWidget(label: "Semua Tipe", isSelected: true),
                      FilterChipWidget(label: "Kelas"),
                      FilterChipWidget(label: "Lab"),
                      FilterChipWidget(label: "Olahraga"),
                      FilterChipWidget(label: "Equipment"),
                      FilterIconWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: facilities.length,
              itemBuilder: (context, index) {
                final item = facilities[index];
                return FacilityCard(
                  title: item.title,
                  description: item.description,
                  category: item.category,
                  isAvailable: item.isAvailable,
                  capacity: item.capacity,
                  location: item.location,
                  features: item.features,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// FILTER CHIP
// -----------------------------------------------------------------------------
class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Colors.blue,
        backgroundColor: Colors.grey.shade200,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        onSelected: (value) {},
      ),
    );
  }
}

class FilterIconWidget extends StatelessWidget {
  const FilterIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.filter_list),
    );
  }
}

// -----------------------------------------------------------------------------
// CARD FASILITAS + NAVIGASI KE HALAMAN BOOKING
// -----------------------------------------------------------------------------
class FacilityCard extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final bool isAvailable;
  final String capacity;
  final String location;
  final List<String> features;

  const FacilityCard({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.isAvailable,
    required this.capacity,
    required this.location,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                BookingPage(facilityName: title, facilityLocation: location),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isAvailable ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isAvailable ? "Tersedia" : "Terpakai",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(description, style: const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.people, size: 18, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(capacity),
                      const SizedBox(width: 15),
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(location),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: features
                        .map(
                          (f) => Chip(
                            label: Text(f),
                            backgroundColor: Colors.grey.shade200,
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(color: Colors.blue),
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

// -----------------------------------------------------------------------------
// HALAMAN BOOKING
// -----------------------------------------------------------------------------
class BookingPage extends StatefulWidget {
  final String facilityName;
  final String facilityLocation;

  const BookingPage({
    super.key,
    required this.facilityName,
    required this.facilityLocation,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;
  String? selectedTime;
  final TextEditingController reasonController = TextEditingController();

  List<String> timeOptions = [
    "07:00 - 09:00",
    "09:00 - 12:00",
    "13:00 - 15:00",
    "15:00 - 17:00",
    "17:00 - 20:00",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Fasilitas"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              widget.facilityName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              widget.facilityLocation,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            const Text(
              "Pilih Tanggal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            InkWell(
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 60)),
                  initialDate: DateTime.now(),
                );

                if (date != null) {
                  setState(() => selectedDate = date);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  selectedDate == null
                      ? "Belum memilih tanggal"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Pilih Jam",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: timeOptions.map((t) {
                return ChoiceChip(
                  label: Text(t),
                  selected: selectedTime == t,
                  selectedColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: selectedTime == t ? Colors.white : Colors.black,
                  ),
                  onSelected: (v) => setState(() => selectedTime = t),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            const Text(
              "Alasan Penggunaan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Tuliskan alasan peminjaman...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                if (selectedDate == null ||
                    selectedTime == null ||
                    reasonController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lengkapi semua data terlebih dahulu"),
                    ),
                  );
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Booking berhasil diajukan!")),
                );

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Ajukan Booking",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
