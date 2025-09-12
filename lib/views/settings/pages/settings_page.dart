import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constant_finals.dart';
import '../../../core/utils/bottom_sheet.dart';
import '../cubit/unbind_speedcash_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _logout() async {
    await _storage.deleteAll();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  void _showLogoutBottomSheet() {
    verifyLogOut(context, _logout);
  }

  // Future<void> _confirmLogout() async {
  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Konfirmasi Logout'),
  //       content: const Text('Apakah Anda yakin ingin logout?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: const Text('Batal'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, true),
  //           child: const Text('Logout'),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (confirmed == true) {
  //     await _logout();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: Screen.kSize64,
          horizontal: Screen.kSize16,
        ),
        children: [
          // Profil
          Card(
            color: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.orange),
              title: Text("Profil"),
              subtitle: Text("Lihat dan edit profil"),
              trailing: Icon(Icons.arrow_forward_ios, size: Screen.kSize18),
            ),
          ),

          // Pengaturan
          Card(
            color: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.settings, color: Colors.orange),
              title: Text("Pengaturan Aplikasi"),
              subtitle: Text("Atur preferensi aplikasi"),
              trailing: Icon(Icons.arrow_forward_ios, size: Screen.kSize18),
            ),
          ),

          Card(
            color: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: BlocListener<UnbindSpeedCashCubit, SpeedcashState>(
              listener: (context, state) {
                if (state is UnbindSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } else if (state is UnbindError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: BlocBuilder<UnbindSpeedCashCubit, SpeedcashState>(
                builder: (context, state) {
                  final isLoading = state is UnbindLoading;
                  return ListTile(
                    leading: const Icon(Icons.wallet, color: Colors.blue),
                    title: Text(
                      "SpeedCash",
                      style: Styles.kNunitoMedium.copyWith(
                        color: Colors.black,
                        fontSize: Screen.kSize18,
                      ),
                    ),
                    subtitle: Text(
                      "Unbind SpeedCash",
                      style: Styles.kNunitoRegular.copyWith(
                        color: Colors.grey[600],
                        fontSize: Screen.kSize16,
                      ),
                    ),
                    trailing: isLoading
                        ? const CircularProgressIndicator()
                        : Icon(
                            Icons.link,
                            size: Screen.kSize18,
                            color: Colors.blue,
                          ),
                    onTap: isLoading
                        ? null
                        : () {
                            showUnbindBottomSheet(context, () {
                              context
                                  .read<UnbindSpeedCashCubit>()
                                  .unbindAccount();
                            });
                          },
                  );
                },
              ),
            ),
          ),
          const Divider(height: 32, thickness: 1),

          // Logout
          Card(
            color: kWhite,
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
              onTap: _showLogoutBottomSheet,
            ),
          ),
        ],
      ),
    );
  }
}
