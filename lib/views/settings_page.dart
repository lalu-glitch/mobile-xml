import 'package:android_id/android_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:xmlapp/viewmodels/speedcash/speedcash_viewmodel.dart';

import '../viewmodels/speedcash/cubit/speedcash_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _storage = const FlutterSecureStorage();
  Map<String, String> _allStorage = {};
  String? _deviceID; // simpan di state
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadAllStorage();
    _loadDeviceId();
  }

  Future<String> _loadDeviceId() async {
    // final deviceInfo = DeviceInfoPlugin();
    // final androidInfo = await deviceInfo.androidInfo;
    const androidIdPlugin = AndroidId();
    final androidId = await androidIdPlugin.getId();
    if (mounted) {
      setState(() {
        _deviceID = androidId;
      });
    }
    return androidId ?? "unknown-android-id";
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
          }
        }
      } catch (e) {
        debugPrint("decode userData error: $e");
      }
    }

    return Scaffold(
      // backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('Pengaturan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orangeAccent[700],
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
              child: ListTile(
                title: Text(
                  key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  displayValue,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                  // onPressed: () => _deleteKey(key),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: displayValue!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("clipboard : $displayValue"),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  tooltip: 'Hapus $key',
                ),
              ),
            );
          }),

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
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.smartphone, color: Colors.orange),
              title: const Text("Device ID"),
              subtitle: Text(_deviceID ?? "Loading..."),
              trailing: const Icon(
                Icons.copy,
                size: 18,
                color: Colors.grey,
              ), // ganti icon biar jelas
              onTap: () {
                if (_deviceID != null) {
                  Clipboard.setData(ClipboardData(text: _deviceID!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Device ID disalin ke clipboard : $_deviceID",
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
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
            child: const ListTile(
              leading: Icon(Icons.settings, color: Colors.orange),
              title: Text("Pengaturan Aplikasi"),
              subtitle: Text("Atur preferensi aplikasi"),
              trailing: Icon(Icons.arrow_forward_ios, size: 18),
            ),
          ),

          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: BlocListener<SpeedcashCubit, SpeedcashState>(
              listener: (context, state) {
                print("state saat ini -- $state");
                if (state is UnbindSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 12),
                    ),
                  );
                } else if (state is UnbindError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 12),
                    ),
                  );
                }
              },
              child: BlocBuilder<SpeedcashCubit, SpeedcashState>(
                builder: (context, state) {
                  print("state saat ini -- $state");
                  final isLoading = state is UnbindLoading;
                  return ListTile(
                    leading: const Icon(Icons.wallet, color: Colors.blue),
                    title: const Text("SpeedCash"),
                    subtitle: const Text("Unbind SpeedCash"),
                    trailing: isLoading
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: isLoading
                        ? null
                        : () {
                            context.read<SpeedcashCubit>().unbindAccount();
                          },
                  );
                },
              ),
            ),
          ),

          ///current
          // Consumer<SpeedcashVM>(
          //   builder: (context, viewModel, child) {
          //     return Card(
          //       color: Colors.white,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       margin: const EdgeInsets.only(bottom: 12),
          //       child: InkWell(
          //         onTap: viewModel.isLoading
          //             ? null
          //             : () async {
          //                 await viewModel.unbindSpeedCash();
          //                 if (viewModel.response != null) {
          //                   ScaffoldMessenger.of(context).showSnackBar(
          //                     SnackBar(
          //                       content: Text(viewModel.error!),
          //                       duration: const Duration(seconds: 2),
          //                     ),
          //                   );
          //                 } else if (viewModel.error != null) {
          //                   ScaffoldMessenger.of(context).showSnackBar(
          //                     SnackBar(
          //                       content: Text(viewModel.error!),
          //                       duration: const Duration(seconds: 2),
          //                     ),
          //                   );
          //                 }
          //               },
          //         child: ListTile(
          //           leading: Icon(Icons.wallet_rounded, color: Colors.blue),
          //           title: Text(
          //             "SpeedCash",
          //             style: TextStyle(
          //               color: Colors.blue[400],
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           subtitle: Text(
          //             viewModel.unbindResponse?.message ??
          //                 viewModel.error ??
          //                 "Atur preferensi aplikasi",
          //             style: TextStyle(
          //               color: viewModel.error != null
          //                   ? Colors.red
          //                   : Colors.black,
          //               fontSize: 14.sp,
          //             ),
          //           ),
          //           trailing: viewModel.isLoading
          //               ? const CircularProgressIndicator()
          //               : const Icon(Icons.arrow_forward_ios, size: 18),
          //         ),
          //       ),
          //     );
          //   },
          // ),
          const Divider(height: 32, thickness: 1),

          // Logout
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
