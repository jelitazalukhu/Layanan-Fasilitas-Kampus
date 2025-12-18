import 'package:flutter/material.dart';
import '../services/facility_service.dart';
import 'daftarfasilitas.dart'; // Reuse for styles/cards if possible, or duplicate logic
import 'dart:async'; // Add import for Timer

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FacilityService _facilityService = FacilityService();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  void _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _facilityService.getFacilities(query: query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      // Sembunyikan error snackbar untuk live search agar tidak mengganggu
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF6),
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Cari gedung, fasilitas...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.black),
          onChanged: _onSearchChanged, // Changed from onSubmitted
          onSubmitted: _performSearch,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _performSearch(_searchController.text),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(
                  child: Text("Cari fasilitas kampus...",
                      style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final data = _searchResults[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            data['imageUrl'] ?? 'assets/usu_logo.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                                width: 60, height: 60, color: Colors.grey),
                          ),
                        ),
                        title: Text(data['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(data['location']),
                        onTap: () {
                          // Show Booking Dialog reused from DaftarFasilitasScreen logic
                          // Or handle navigation. For simplicity, we can show dialog here too.
                          // But BookingDialog is inside DaftarFasilitasScreen file and private state/widget.
                          // We should technically export BookingDialog or move it to a shared file.
                          // Ideally refactor, but for now let's just show a simple dialog or nothing.
                          showDialog(
                            context: context,
                            builder: (context) => BookingDialogWrapper(facility: data),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

// Wrapper to access BookingDialog if we can't easily import the private one, 
// OR we move BookingDialog to a separate public widget. 
// For this step I will assume BookingDialog needs to be extracted or I copy it.
// Checking `daftarfasilitas.dart`, BookingDialog is a public class (no underscore).
// So I can import it if I import `daftarfasilitas.dart`.
class BookingDialogWrapper extends StatelessWidget {
    final dynamic facility;
    const BookingDialogWrapper({super.key, required this.facility});

    @override
    Widget build(BuildContext context) {
        return BookingDialog(facility: facility);
    }
}
