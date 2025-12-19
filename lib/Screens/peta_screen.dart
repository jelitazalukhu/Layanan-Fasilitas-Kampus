import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PetaScreen extends StatefulWidget {
  const PetaScreen({super.key});

  @override
  State<PetaScreen> createState() => _PetaScreenState();
}

class _PetaScreenState extends State<PetaScreen> {
  // Koordinat Pusat USU
  final LatLng _centerUSU = const LatLng(3.5644, 98.6596);

  // Data Fasilitas Hardcoded untuk Demo
  final List<Map<String, dynamic>> _locations = [
    {
      "name": "Biro Pusat Administrasi USU",
      "point": const LatLng(3.5644, 98.6596),
      "icon": Icons.school,
      "color": Colors.blue,
    },
    {
      "name": "Auditorium USU",
      "point": const LatLng(3.5652, 98.6601),
      "icon": Icons.theater_comedy,
      "color": Colors.orange,
    },
    {
      "name": "Perpustakaan USU",
      "point": const LatLng(3.5638, 98.6589),
      "icon": Icons.local_library,
      "color": Colors.green,
    },
    {
      "name": "Masjid Al-Jami'ah (Masjid Kampus)",
      "point": const LatLng(3.5610, 98.6575),
      "icon": Icons.mosque,
      "color": Colors.green,
    },
    {
      "name": "Fakultas MIPA",
      "point": const LatLng(3.5605, 98.6558),
      "icon": Icons.science,
      "color": Colors.purple,
    },
    {
      "name": "Fakultas Vokasi",
      "point": const LatLng(3.5620, 98.6565),
      "icon": Icons.build,
      "color": Colors.brown,
    },
    {
      "name": "Fakultas Kedokteran",
      "point": const LatLng(3.5670, 98.6580), 
      "icon": Icons.medical_services,
      "color": Colors.red,
    },
    {
      "name": "Poliklinik USU",
      "point": const LatLng(3.5665, 98.6590),
      "icon": Icons.local_hospital,
      "color": Colors.redAccent,
    },
     {
      "name": "Pintu 1 USU",
      "point": const LatLng(3.5685, 98.6570), // Perkiraan
      "icon": Icons.door_front_door,
      "color": Colors.grey,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Peta Kampus USU", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _centerUSU,
          initialZoom: 15.5,
          minZoom: 13.0,
          maxZoom: 18.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.layanan_fasilitas_kampus',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _locations.map((loc) {
              return Marker(
                point: loc['point'],
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        height: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(loc['icon'], color: loc['color'], size: 30),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    loc['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Tap untuk info lebih lanjut atau navigasi (mockup).",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                       Icon(
                          Icons.location_on,
                          color: loc['color'],
                          size: 40,
                        ),
                        // Label kecil di bawah marker (opsional)
                    ],
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
