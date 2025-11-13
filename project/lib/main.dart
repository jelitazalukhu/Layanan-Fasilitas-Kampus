import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _idx = 0;

  final _halaman = [
    DaftarKontak(), 
    Pengaturan(),   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Widget (Bagian 2)'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search))
        ],
      ),

      body: _halaman[_idx],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class DaftarKontak extends StatelessWidget {
  final List<Map<String, dynamic>> data = [
    {'nama': 'Budi', 'telp': '081111', 'avatar':  'https://ui-avatars.com/api/?name=Budi&background=random'},
    {'nama': 'Ani', 'telp': '082222', 'avatar':  'https://ui-avatars.com/api/?name=Ani&background=random'},
    {'nama': 'Citra', 'telp': '083333', 'avatar': 'https://ui-avatars.com/api/?name=Citra&background=random'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, i) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          leading: CircleAvatar(
          backgroundImage: NetworkImage(data[i]['avatar'])),
          title: Text(data[i]['nama']),
          subtitle: Text(data[i]['telp']),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {}, 
        ),
      ),
    );
  }
}


class Pengaturan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 80, color: Colors.blueGrey),
          SizedBox(height: 12),
          Text('Halaman Pengaturan', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}