import 'package:flutter/material.dart';

import '../../views/auth/pages/otp_page.dart';
import '../../views/auth/pages/lupa_kode_agen.dart';
import '../../views/auth/pages/auth_page.dart';
import '../../main_page.dart';
import '../../views/auth/pages/SK_page.dart';
import '../../views/input_nomor/input_nomer_awal.dart';
import '../../views/input_nomor/input_nomer_mid.dart';
import '../../views/komisi/pages/komisi_pages.dart';
import '../../views/multi_sub_kategori_page.dart';
import '../../views/onboarding/onboarding_screen.dart';
import '../utils/webview.dart';
import '../../views/analytics/analytics_page.dart';
import '../../views/input_nomor/input_nomor_tujuan_page.dart';
import '../../views/layanan/noprefix/noprefix_page.dart';
import '../../views/layanan/prefix/prefix_page.dart';
import '../../views/speedcash/pages/speedcash_binding.dart';
import '../../views/speedcash/pages/speedcash_deposit.dart';
import '../../views/speedcash/pages/speedcash_register.dart';
import '../../views/home/page/home_page.dart';
import '../../views/transaksi/konfirmasi_page.dart';
import '../../views/riwayat/riwayat_detail.dart';
import '../../views/riwayat/riwayat_page.dart';
import '../../views/settings/pages/settings_page.dart';
import '../../views/shops/shops_page.dart';
import '../../data/services/auth_guard.dart';
import '../../views/struk.dart';
import '../../views/transaksi/transaksi_detail_page.dart';
import '../../views/transaksi/transaksi_proses_page.dart';

Widget authGuardWrapper(Widget child) {
  return AuthGuard(child: child);
}

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => authGuardWrapper(const MainPage()),
  '/onboarding': (context) => const OnboardingScreen(),
  '/lupaKodeAgen': (context) => (LupaKodeAgenPage()),
  '/authPage': (context) => (AuthPage()),
  '/kodeOTP': (context) => (KodeOTP()),
  '/S&KPage': (context) => (SyaratDanKetentuan()),
  '/homepage': (context) => authGuardWrapper(HomePage()),
  '/settings': (context) => authGuardWrapper(SettingsPage()),
  '/shops': (context) => authGuardWrapper(const ShopsPage()),
  '/analytics': (context) => authGuardWrapper(const AnalyticsPage()),
  '/detailPrefix': (context) => authGuardWrapper(DetailPrefixPage()),
  '/detailNoPrefix': (context) => authGuardWrapper(DetailNoPrefixPage()),
  '/multiSubKategori': (context) =>
      authGuardWrapper(const MultiSubKategoriPage()),
  '/riwayatTransaksi': (context) => authGuardWrapper(RiwayatTransaksiPage()),
  '/struk': (context) => authGuardWrapper(StrukPage(transaksi: null)),
  '/komisiPage': (context) => authGuardWrapper(KomisiPage()),
  '/detailRiwayatTransaksi': (context) => authGuardWrapper(DetailRiwayatPage()),
  '/inputNomorTujuan': (context) => authGuardWrapper(InputNomorTujuanPage()),
  '/inputNomorFirst': (context) => authGuardWrapper(InputNomorPage()),
  '/inputNomorMid': (context) => authGuardWrapper(InputNomorMidPage()),
  '/konfirmasiPembayaran': (context) =>
      authGuardWrapper(KonfirmasiPembayaranPage()),
  '/transaksiProses': (context) => authGuardWrapper(TransaksiProsesPage()),
  '/transaksiDetail': (context) =>
      authGuardWrapper(const DetailTransaksiPage()),
  '/speedcashBindingPage': (context) =>
      authGuardWrapper(SpeedcashBindingPage()),
  '/speedcashRegisterPage': (context) =>
      authGuardWrapper(SpeedcashRegisterPage()),
  '/speedcashDepositPage': (context) =>
      authGuardWrapper(const SpeedcashDepositPage()),

  '/webView': (context) => authGuardWrapper(WebviewPage(url: '', title: '')),
};
