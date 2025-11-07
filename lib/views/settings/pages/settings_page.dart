import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/helper/error_handler.dart';
import '../../../core/utils/bottom_sheet.dart';
import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/shimmer.dart';
import '../../../data/models/user/info_akun.dart';
import '../../../viewmodels/balance_viewmodel.dart';
import '../../../core/helper/error_handler.dart';
import '../cubit/info_akun/info_akun_cubit.dart';
import '../helper/menu_item.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/wallet_item_settings.dart';
import '../widgets/setting_user_header.dart';
import '../widgets/logout_card.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<InfoAkunCubit>().getInfoAkun();
  }

  /// Fungsi logout (hapus semua data lalu arahkan ke halaman login)
  Future<void> _logout() async {
    await _storage.delete(key: 'userData');
    if (mounted) {
      context.read<BalanceViewModel>().reset();
      Navigator.pushNamedAndRemoveUntil(context, '/authPage', (route) => false);
    }
  }

  /// Menampilkan konfirmasi logout
  void _showLogoutBottomSheet() {
    verifyLogOut(context, _logout);
  }

  /// buat refresh
  void refresh() {
    context.read<InfoAkunCubit>().getInfoAkun();
  }

  @override
  Widget build(BuildContext context) {
    final List<MenuItem> accountInfoItems = [
      MenuItem(
        imagePath: 'assets/icons/user-filled-icon.png',
        title: 'Profil Saya',
        onTap: () => Navigator.pushNamed(context, '/detailInfoAkun'),
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
        onTap: () => Navigator.pushNamed(context, '/riwayatTransaksi'),
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
        onTap: () => Navigator.pushNamed(context, '/poinPage'),
      ),
      MenuItem(
        imagePath: 'assets/icons/coin-bag-icon.png',
        title: 'Tukar Komisi',
        onTap: () => Navigator.pushNamed(context, '/komisiPage'),
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

    return RefreshIndicator(
      color: kOrange,
      onRefresh: () => context.read<InfoAkunCubit>().getInfoAkun(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kOrange,
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          title: Text('Akun saya', style: TextStyle(color: kWhite)),
          actionsPadding: EdgeInsets.only(right: 16),
          actions: [Icon(Icons.search_rounded, color: kWhite)],
        ),
        backgroundColor: kBackground,
        body: BlocBuilder<InfoAkunCubit, InfoAkunState>(
          builder: (context, state) {
            if (state is InfoAkunLoading) {
              return ShimmerBox.buildShimmerSettings();
            }

            if (state is InfoAkunLoaded) {
              return Column(
                children: [
                  SettingHeader(state: state), // Header profil user
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: kSize32,
                        horizontal: kSize16,
                      ),
                      itemCount: 8, // Total sections + other widgets
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            // --- DOMPET APLIKASI ---
                            return SizedBox(
                              height: (state.data.data.ewallet?.isEmpty ?? true)
                                  ? 0
                                  : 120, // tinggi maksimum kontainer kalo ada ewallet
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.data.data.ewallet?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final Ewallet currentEwallet =
                                      state.data.data.ewallet![index];
                                  return WalletItem(ewallet: currentEwallet);
                                },
                              ),
                            );
                          case 1:
                            return _buildSection(
                              context,
                              'Informasi Akun',
                              accountInfoItems,
                            );
                          case 2:
                            return _buildSection(
                              context,
                              'Riwayat',
                              historyItems,
                            );
                          case 3:
                            return _buildSection(
                              context,
                              'Transaksi',
                              transactionItems,
                            );
                          case 4:
                            return _buildSection(
                              context,
                              'Menu Agen',
                              menuAgenItem,
                            );
                          case 5:
                            return _buildSection(
                              context,
                              'Bantuan',
                              bantuanItem,
                            );
                          case 6:
                            return const Divider(height: 32, thickness: 1);
                          case 7:
                            return LogoutCard(onTap: _showLogoutBottomSheet);
                          default:
                            return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is InfoAkunError) {
              return ErrorHandler(
                error: 'Ada yang salah. Silahkan coba lagi.',
                onRetry: refresh,
              );
            }

            return const SizedBox.shrink();
          },
        ),
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
