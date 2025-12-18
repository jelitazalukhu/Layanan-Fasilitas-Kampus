import 'package:flutter/material.dart';
import '../Screens/ganti_pw.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // dummy data (nanti dari auth / database)
  final String name = "Jelita Zalukhu";
  final String nim = "221402XXX";
  final String prodi = "Teknik Informatika";
  final String fakultas = "Fakultas Vokasi";
  final String email = "nama@students.usu.ac.id";
  final String phone = "+62 8xxxxxxxxxx";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF6),

      /// ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF3FBF6),
        centerTitle: true,
        title: const Text(
          "Profil",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// ================= HEADER PROFIL =================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  /// AVATAR INISIAL
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: const Color(0xFF22C55E),
                    child: Text(
                      _getInitials(name),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("NIM: $nim"),
                  const SizedBox(height: 4),
                  Text("$prodi • $fakultas", textAlign: TextAlign.center),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ================= INFORMASI AKUN =================
            _ProfileSection(
              title: "Informasi Akun",
              children: [
                _ProfileItem(
                  icon: Icons.email_outlined,
                  title: "Email Kampus",
                  value: email,
                ),
                _ProfileItem(
                  icon: Icons.phone_outlined,
                  title: "Nomor HP",
                  value: phone,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ================= PENGATURAN AKUN =================
            _ProfileSection(
              title: "Pengaturan Akun",
              children: [
                _ProfileAction(
                  icon: Icons.lock_outline,
                  title: "Ganti Password",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                _ProfileAction(
                  icon: Icons.info_outline,
                  title: "Tentang Aplikasi",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutAppScreen()),
                    );
                  },
                ),
                _ProfileAction(
                  icon: Icons.logout,
                  title: "Logout",
                  isDanger: true,
                  onTap: () {
                    // TODO: logout logic
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= WIDGET PENDUKUNG =================

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDanger;

  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color? color = isDanger ? Colors.red : null;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

/// ================= ABOUT APP =================

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FBF6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF3FBF6),
        title: const Text(
          "Tentang Aplikasi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "CampusFind adalah aplikasi untuk membantu mahasiswa "
          "menemukan fasilitas dan layanan kampus dengan mudah.",
        ),
      ),
    );
  }
}

/// ================= HELPER =================

String _getInitials(String name) {
  final parts = name.trim().split(" ");
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return (parts[0][0] + parts[1][0]).toUpperCase();
}
