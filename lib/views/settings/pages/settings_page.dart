import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:xmlapp/core/utils/error_dialog.dart';

import '../../../core/constant_finals.dart';
import '../../../core/utils/bottom_sheet.dart';
import '../cubit/info_akun_cubit.dart';
import '../cubit/unbind_speedcash_cubit.dart';
import '../widgets/error_view.dart';
import '../widgets/header.dart';
import '../widgets/setting_card.dart';
import '../widgets/settings_shimmer.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InfoAkunCubit>().getInfoAkun();
    });
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
      body: BlocBuilder<InfoAkunCubit, InfoAkunState>(
        builder: (context, state) {
          if (state is InfoAkunLoading) {
            // SHIMMER LOADING UI
            return InfoAkunShimmer();
          }
          if (state is InfoAkunSuccess) {
            return Column(
              children: [
                Header(state: state),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      vertical: Screen.kSize32,
                      horizontal: Screen.kSize16,
                    ),
                    children: [
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
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: Screen.kSize18,
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// Dropdown ala-ala
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
                                margin: const EdgeInsets.only(
                                  right: 8,
                                  bottom: 12,
                                ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Image.asset(
                                          'assets/images/logo-speedcash.png',
                                        ),
                                        Spacer(),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kOrange,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                          child: Text(
                                            'Hubungkan',
                                            style: Styles.kNunitoMedium
                                                .copyWith(
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

                      ///Produk Favorit
                      SettingCard(
                        title: 'Produk Favorit',
                        icons: Icons.bookmark_add_rounded,
                        onTap: () {
                          showInfoToast('Produk Favorit');
                        },
                      ),

                      ///Riwayat Transaksi
                      SettingCard(
                        title: 'Riwayat Transaksi',
                        icons: Icons.history_rounded,
                        onTap: () {
                          showInfoToast('Riwayat Transaksi');
                        },
                      ),

                      ///Tukar Poin & Komisi
                      SettingCard(
                        title: 'Tukar Poin & Komisi',
                        icons: Icons.history_rounded,
                        onTap: () {
                          showInfoToast('Tukar Poin & Komisi');
                        },
                      ),

                      ///Riwayat Deposit
                      SettingCard(
                        title: 'Riwayat Deposit',
                        icons: Icons.add_circle_rounded,
                        onTap: () {
                          showInfoToast('Riwayat Deposit');
                        },
                      ),

                      const Divider(color: kNeutral50),
                      SizedBox(height: Screen.kSize11),

                      ///Daftarkan Downline
                      SettingCard(
                        title: 'Daftarkan Downline',
                        icons: Icons.person_add_alt_1_rounded,
                        onTap: () {
                          showInfoToast('Daftarkan Downline');
                        },
                      ),

                      ///List Downline
                      SettingCard(
                        title: 'List Downline',
                        icons: Icons.groups_2_rounded,
                        onTap: () {
                          showInfoToast('List Downline');
                        },
                      ),

                      const Divider(color: kNeutral50),
                      SizedBox(height: Screen.kSize11),

                      ///Pengaturan
                      SettingCard(
                        title: 'Pengaturan',
                        icons: Icons.settings,
                        onTap: () {
                          showInfoToast('Pengaturan');
                        },
                      ),

                      ///Hubungi CS
                      SettingCard(
                        title: 'Hubungi CS',
                        icons: Icons.headset_mic_rounded,
                        onTap: () {
                          showInfoToast('Hubungi CS');
                        },
                      ),

                      Card(
                        color: kWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child:
                            BlocListener<UnbindSpeedCashCubit, SpeedcashState>(
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
                              child:
                                  BlocBuilder<
                                    UnbindSpeedCashCubit,
                                    SpeedcashState
                                  >(
                                    builder: (context, state) {
                                      final isLoading = state is UnbindLoading;
                                      return ListTile(
                                        leading: const Icon(
                                          Icons.wallet,
                                          color: Colors.blue,
                                        ),
                                        title: Text("SpeedCash"),
                                        subtitle: Text("Unbind SpeedCash"),
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
                                                showUnbindBottomSheet(
                                                  context,
                                                  () {
                                                    context
                                                        .read<
                                                          UnbindSpeedCashCubit
                                                        >()
                                                        .unbindAccount();
                                                  },
                                                );
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
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.redAccent,
                          ),
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
                ),
              ],
            );
          }
          if (state is InfoAkunError) {
            return ErrorView(
              state: state.message,
              onRetry: context.read<InfoAkunCubit>().getInfoAkun(),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
