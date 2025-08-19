import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

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
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
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

  /// Ambil info expired dari JWT
  String? getExpiredInfoFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final data = jsonDecode(payload);

      if (data is! Map) return null;

      if (data.containsKey("exp")) {
        final exp = DateTime.fromMillisecondsSinceEpoch(
          (data["exp"] as int) * 1000,
        );
        final now = DateTime.now();
        final formatted = DateFormat("yyyy-MM-dd HH:mm:ss").format(exp);

        if (exp.isBefore(now)) {
          return "❌ Expired pada: $formatted";
        } else {
          return "✅ Berlaku sampai: $formatted";
        }
      }
    } catch (e) {
      debugPrint("JWT decode error: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Ambil access + refresh token dari userData
    String? accessInfo;
    String? refreshToken;
    String? refreshInfo;

    if (_allStorage.containsKey("userData")) {
      try {
        final decoded = jsonDecode(_allStorage["userData"]!);
        if (decoded is Map) {
          final accessToken = decoded["accessToken"];
          refreshToken = decoded["refreshToken"];
          if (accessToken is String) {
            accessInfo = getExpiredInfoFromJwt(accessToken);
          }
          if (refreshToken is String) {
            // refreshToken biasanya bukan JWT, jadi hanya tampilkan raw
            refreshInfo = getExpiredInfoFromJwt(refreshToken) ?? refreshToken;
          }
        }
      } catch (e) {
        debugPrint("decode userData error: $e");
      }
    }

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        children: [
          // 🔑 Semua key dari storage
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
              margin: const EdgeInsets.only(bottom: 4),
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

          // 🟢 Section khusus info JWT Expired
          const Text(
            "Info Token",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),

          if (accessInfo != null)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),

              child: ListTile(
                leading: Icon(
                  accessInfo.contains("Expired")
                      ? Icons.cancel
                      : Icons.check_circle,
                  color: accessInfo.contains("Expired")
                      ? Colors.red
                      : Colors.green,
                ),
                title: const Text("Access Token"),
                subtitle: Text(accessInfo),
              ),
            ),

          const Divider(height: 32, thickness: 1),

          // Profil
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

          // Pengaturan
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

          // Logout
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
    );
  }
}
