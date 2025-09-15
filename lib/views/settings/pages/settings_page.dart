import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constant_finals.dart';
import '../../../core/helper/bottom_sheet.dart';
import '../cubit/info_akun_cubit.dart';
import '../widgets/error_view.dart';
import '../widgets/header.dart';
import '../widgets/logout_card.dart';
import '../widgets/setting_card.dart';
import '../widgets/settings_shimmer.dart';
import '../widgets/wallet_section.dart';

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
    // Ambil data akun setelah widget selesai dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InfoAkunCubit>().getInfoAkun();
    });
  }

  /// Fungsi logout (hapus semua data lalu arahkan ke halaman login)
  Future<void> _logout() async {
    await _storage.deleteAll();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  /// Menampilkan konfirmasi logout
  void _showLogoutBottomSheet() {
    verifyLogOut(context, _logout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<InfoAkunCubit, InfoAkunState>(
        builder: (context, state) {
          if (state is InfoAkunLoading) {
            return const InfoAkunShimmer();
          }

          if (state is InfoAkunSuccess) {
            return Column(
              children: [
                Header(state: state), // Header profil user
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      vertical: Screen.kSize32,
                      horizontal: Screen.kSize16,
                    ),
                    children: [
                      /// --- DOMPET APLIKASI ---
                      WalletSection(
                        isExpanded: isMuncul,
                        onTap: () {
                          setState(() {
                            isMuncul = !isMuncul;
                          });
                        },
                        ewallets: state.data.data.ewallet,
                      ),

                      /// --- MENU LAIN ---
                      SettingCard(
                        title: 'Produk Favorit',
                        icons: Icons.bookmark_add_rounded,
                        onTap: () {},
                      ),
                      SettingCard(
                        title: 'Riwayat Transaksi',
                        icons: Icons.history_rounded,
                        onTap: () {
                          Navigator.pushNamed(context, '/riwayatTransaksi');
                        },
                      ),
                      SettingCard(
                        title: 'Tukar Poin & Komisi',
                        icons: Icons.local_parking,
                        onTap: () {},
                      ),
                      SettingCard(
                        title: 'Riwayat Deposit',
                        icons: Icons.add_circle_rounded,
                        onTap: () {},
                      ),

                      const Divider(color: kNeutral50),
                      SizedBox(height: Screen.kSize11),

                      SettingCard(
                        title: 'Daftarkan Downline',
                        icons: Icons.person_add_alt_1_rounded,
                        onTap: () {},
                      ),
                      SettingCard(
                        title: 'List Downline',
                        icons: Icons.groups_2_rounded,
                        onTap: () {},
                      ),

                      const Divider(color: kNeutral50),
                      SizedBox(height: Screen.kSize11),

                      SettingCard(
                        title: 'Pengaturan',
                        icons: Icons.settings,
                        onTap: () {},
                      ),
                      SettingCard(
                        title: 'Hubungi CS',
                        icons: Icons.headset_mic_rounded,
                        onTap: () => showCSBottomSheet(context, "Hubungi CS"),
                      ),

                      const Divider(height: 32, thickness: 1),

                      /// --- LOGOUT ---
                      LogoutCard(onTap: _showLogoutBottomSheet),
                    ],
                  ),
                ),
              ],
            );
          }

          if (state is InfoAkunError) {
            return ErrorView(
              errorMessage: state.message,
              onRetry: () => context.read<InfoAkunCubit>().getInfoAkun(),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
