import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/utils/bottom_sheet.dart';
import '../../../core/helper/constant_finals.dart';
import '../cubit/info_akun_cubit.dart';
import '../helper/menu_item.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/error_view.dart';
import '../widgets/setting_header.dart';
import '../widgets/logout_card.dart';
import '../widgets/settings_shimmer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _storage = const FlutterSecureStorage();
  bool isMuncul = false;

  // Sementara definisi data untuk setiap bagian
  final List<MenuItem> accountInfoItems = [
    MenuItem(
      imagePath: 'assets/icons/user-filled-icon.png',
      title: 'Profil Saya',
      onTap: () => debugPrint('Navigasi ke Profil Saya'),
    ),
    MenuItem(
      imagePath: 'assets/icons/verify-icon.png',
      title: 'Verifikasi Akun',
      label: 'MITRA VVIP',
      onTap: () => debugPrint('Navigasi ke Verifikasi Akun'),
    ),
  ];

  final List<MenuItem> historyItems = [
    MenuItem(
      imagePath: 'assets/icons/transaction-history-icon.png',
      title: 'Riwayat Transaksi',
      onTap: () => debugPrint('Navigasi ke Riwayat Transaksi'),
    ),
    MenuItem(
      imagePath: 'assets/icons/top-up-icon.png',
      title: 'Riwayat Top Up',
      onTap: () => debugPrint('Navigasi ke Riwayat Top Up'),
    ),
    MenuItem(
      imagePath: 'assets/icons/transfer-icon.png',
      title: 'Riwayat Transfer Saldo',
      onTap: () => debugPrint('Navigasi ke Riwayat Transfer Saldo'),
    ),
  ];

  final List<MenuItem> transactionItems = [
    MenuItem(
      imagePath: 'assets/icons/whatsapp-icon.png',
      title: 'Center Whatsapp',
      label: 'Baru',
      onTap: () => debugPrint('Navigasi ke Center Whatsapp'),
    ),
    MenuItem(
      imagePath: 'assets/icons/message-icon.png',
      title: 'Center Messenger',
      onTap: () => debugPrint('Navigasi ke Center Messenger'),
    ),
    MenuItem(
      imagePath: 'assets/icons/deposit-icon.png',
      title: 'Tukar Poin',
      onTap: () => debugPrint('Navigasi ke Tukar Poin'),
    ),
    MenuItem(
      imagePath: 'assets/icons/coin-bag-icon.png',
      title: 'Tukar Komisi',
      onTap: () => debugPrint('Navigasi ke Tukar Komisi'),
    ),
    MenuItem(
      imagePath: 'assets/icons/calculator-icon.png',
      title: 'Rekap Piutang',
      onTap: () => debugPrint('Navigasi ke Rekap Piutang'),
    ),
    MenuItem(
      imagePath: 'assets/icons/printer-icon.png',
      title: 'Cetak Struk',
      label: 'Baru',
      onTap: () => debugPrint('Navigasi ke Cetak Struk'),
    ),
  ];

  final List<MenuItem> menuAgenItem = [
    MenuItem(
      imagePath: 'assets/icons/user-with-some-box-icon.png',
      title: 'List Jaringan',
      onTap: () => debugPrint('Navigasi ke List Jaringan'),
    ),
    MenuItem(
      imagePath: 'assets/icons/user-list-icon.png',
      title: 'List Paralel',
      onTap: () => debugPrint('Navigasi ke List Paralel'),
    ),
    MenuItem(
      imagePath: 'assets/icons/user-add-icon.png',
      title: 'Daftarkan Jaringan',
      onTap: () => debugPrint('Navigasi ke Daftarkan Jaringan'),
    ),
  ];

  final List<MenuItem> bantuanItem = [
    MenuItem(
      imagePath: 'assets/icons/user-question-icon.png',
      title: 'Tutorial Penggunaan',
      label: 'Baru',
      onTap: () => debugPrint('Navigasi ke Tutorial Penggunaan'),
    ),
    MenuItem(
      imagePath: 'assets/icons/whatsapp-icon.png',
      title: 'CS Whatsapp',
      onTap: () => debugPrint('Navigasi ke CS Whatsapp'),
    ),
    MenuItem(
      imagePath: 'assets/icons/telegram-icon.png',
      title: 'CS Telegram',
      onTap: () => debugPrint('Navigasi ke CS Telegram'),
    ),
    MenuItem(
      imagePath: 'assets/icons/wallet-icon.png',
      title: 'CS Deposit',
      onTap: () => debugPrint('Navigasi ke CS Deposit'),
    ),
    MenuItem(
      imagePath: 'assets/icons/phone-notification-icon.png',
      title: 'Channel Telegram',
      onTap: () => debugPrint('Navigasi ke Channel Telegram'),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<InfoAkunCubit>().getInfoAkun();
  }

  /// Fungsi logout (hapus semua data lalu arahkan ke halaman login)
  Future<void> _logout() async {
    await _storage.delete(key: 'userData');
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/authPage', (route) => false);
    }
  }

  /// Menampilkan konfirmasi logout
  void _showLogoutBottomSheet() {
    verifyLogOut(context, _logout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kOrange,
        surfaceTintColor: Colors.transparent,
        title: Text('Akun saya', style: TextStyle(color: kWhite)),
        actionsPadding: EdgeInsets.only(right: 16),
        actions: [Icon(Icons.search_rounded, color: kWhite)],
      ),
      backgroundColor: kBackground,
      body: BlocBuilder<InfoAkunCubit, InfoAkunState>(
        builder: (context, state) {
          if (state is InfoAkunLoading) {
            return const InfoAkunShimmer();
          }

          if (state is InfoAkunLoaded) {
            return Column(
              children: [
                SettingHeader(state: state), // Header profil user
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      vertical: Screen.kSize32,
                      horizontal: Screen.kSize16,
                    ),
                    children: [
                      /// --- DOMPET APLIKASI ---
                      SizedBox(
                        height: 120, // tinggi maksimum kontainer ListView
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 16),
                              width: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.pinkAccent,
                                  width: 3.5,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize
                                      .min, // biar tinggi mengikuti isi
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Image.asset(
                                        'assets/images/logo-speedcash.png',
                                        scale: 3,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: double.infinity,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[700],
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Binding',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      _buildSection(
                        context,
                        'Informasi Akun',
                        accountInfoItems,
                      ),
                      _buildSection(context, 'Riwayat', historyItems),
                      _buildSection(context, 'Transaksi', transactionItems),
                      _buildSection(context, 'Menu Agen', menuAgenItem),
                      _buildSection(context, 'Bantuan', bantuanItem),
                      const Divider(height: 32, thickness: 1),

                      /// --- LOGOUT --- ///
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

  // Fungsi helper untuk membangun setiap bagian secara dinamis
  Widget _buildSection(
    BuildContext context,
    String title,
    List<MenuItem> items,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Judul Bagian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kBlack,
              ),
            ),
          ),
          // Kartu (Card) yang membungkus semua item di bagian ini
          Card(
            color: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: items.map((item) {
                // Widget CustomListTile yang dapat digunakan kembali
                return CustomListTile(
                  imagePath: item.imagePath,
                  title: item.title,
                  label: item.label,
                  onTap: item.onTap,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
