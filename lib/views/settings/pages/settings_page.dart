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
  bool isMuncul = false;

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

          GestureDetector(
            onTap: () {
              setState(() {
                isMuncul = !isMuncul;
              });
            },
            child: Card(
              color: kWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  Icons.card_membership_sharp,
                  color: Colors.orange,
                ),
                title: Text("Dompet Aplikasi"),
                trailing: AnimatedRotation(
                  turns: isMuncul ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.arrow_forward_ios, size: Screen.kSize18),
                ),
              ),
            ),
          ),

          Visibility(
            visible: isMuncul,
            child: SizedBox(
              width: double.infinity,
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10, // jumlah placeholder
                itemBuilder: (context, index) {
                  return Container(
                    width: 250,
                    margin: const EdgeInsets.only(right: 8, bottom: 12),
                    decoration: BoxDecoration(
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          color: kNeutral70.withAlpha(15),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(1, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset('assets/images/logo-speedcash.png'),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                'Hubungkan',
                                style: Styles.kNunitoMedium.copyWith(
                                  color: kWhite,
                                  fontSize: Screen.kSize16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
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
