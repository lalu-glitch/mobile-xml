import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_guard.dart';
import 'dart:convert';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _storage = const FlutterSecureStorage();

  Map<String, String> _allStorage = {};

  @override
  void initState() {
    super.initState();
    _loadAllStorage();
  }

  Future<void> _loadAllStorage() async {
    final allValues = await _storage.readAll();
    if (mounted) {
      setState(() {
        _allStorage = allValues;
      });
    }
  }

  Future<void> _deleteKey(String key) async {
    await _storage.delete(key: key);
    await _loadAllStorage(); // refresh setelah hapus
  }

  Future<void> _logout() async {
    await _storage.deleteAll();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (_allStorage.isEmpty) {
    //   return Scaffold(
    //     appBar: AppBar(title: const Text('Pengaturan')),
    //     body: const Center(child: Text('Tidak ada data di local storage')),
    //   );
    // }

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        color: Colors.orange[50], // background lembut
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          children: [
            ..._allStorage.entries.map((entry) {
              final key = entry.key;
              final rawValue = entry.value;

              String displayValue;
              try {
                final decoded = jsonDecode(rawValue);
                if (decoded is List || decoded is Map) {
                  displayValue = const JsonEncoder.withIndent(
                    '  ',
                  ).convert(decoded);
                } else {
                  displayValue = rawValue;
                }
              } catch (e) {
                displayValue = rawValue;
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                child: ListTile(
                  title: Text(
                    key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    displayValue,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                    onPressed: () => _deleteKey(key),
                    tooltip: 'Hapus $key',
                  ),
                ),
              );
            }).toList(),

            const Divider(height: 32, thickness: 1),

            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              child: const ListTile(
                leading: Icon(Icons.person, color: Colors.orange),
                title: Text("Profil"),
                subtitle: Text("Lihat dan edit profil"),
                trailing: Icon(Icons.arrow_forward_ios, size: 18),
              ),
            ),

            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              child: const ListTile(
                leading: Icon(Icons.settings, color: Colors.orange),
                title: Text("Pengaturan Aplikasi"),
                subtitle: Text("Atur preferensi aplikasi"),
                trailing: Icon(Icons.arrow_forward_ios, size: 18),
              ),
            ),

            const Divider(height: 32, thickness: 1),

            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: _confirmLogout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
