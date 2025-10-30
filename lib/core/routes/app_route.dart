import 'package:flutter/material.dart';

import '../../views/auth/pages/lupa_kode_agen.dart';
import '../../views/auth/pages/otp_page.dart';
import '../../views/auth/pages/auth_page.dart';
import '../../main_page.dart';
import '../../views/auth/pages/SK_page.dart';
import '../../views/input_nomor/input_nomer_awal.dart';
import '../../views/input_nomor/input_nomer_mid.dart';
import '../../views/onboarding/onboarding_screen.dart';
import '../../views/poin_dan_komisi/pages/komisi/pages/status_tukar_komisi_page.dart';
import '../../views/poin_dan_komisi/pages/komisi/pages/komisi_page.dart';
import '../../views/multi_sub_kategori_page.dart';
import '../../views/poin_dan_komisi/pages/poin/pages/detail_tukar_poin_page.dart';
import '../../views/poin_dan_komisi/pages/poin/pages/poin_page.dart';
import '../../views/poin_dan_komisi/pages/poin/pages/status_tukar_poin_page.dart';
import '../../views/poin_dan_komisi/pages/poin/pages/verifikasi_tukar_poin_page.dart';
import '../../views/riwayat/pages/riwayat_page.dart';
import '../../views/settings/pages/detail_akun_page.dart';
import '../../views/speedcash/pages/speedcash_topup_tiket.dart';
import '../helper/onboarding_guard.dart';
import '../utils/webview.dart';
import '../../views/analytics/analytics_page.dart';
import '../../views/input_nomor/input_nomor_akhir.dart';
import '../../views/layanan/noprefix/noprefix_page.dart';
import '../../views/layanan/prefix/prefix_page.dart';
import '../../views/speedcash/pages/speedcash_binding.dart';
import '../../views/speedcash/pages/speedcash_topup_list_bank.dart';
import '../../views/speedcash/pages/speedcash_register.dart';
import '../../views/home/page/home_page.dart';
import '../../views/transaksi/konfirmasi_pembayaran_page.dart';
import '../../views/settings/pages/settings_page.dart';
import '../../views/shops/pages/shop_page.dart';
import '../helper/auth_guard.dart';
import '../../views/struk.dart';
import '../../views/transaksi/transaksi_detail_page.dart';
import '../../views/transaksi/transaksi_proses_page.dart';

Widget authGuardWrapper(Widget child) {
  return AuthGuard(child: child);
}

Widget onboardingGuardWrapper(Widget child) {
  return OnboardingGuard(child: child);
}

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => onboardingGuardWrapper(authGuardWrapper(const MainPage())),
  '/onboarding': (context) => const OnboardingScreen(),
  '/lupaKodeAgen': (context) => LupaKodeAgenPage(),
  '/authPage': (context) => AuthPage(),
  '/kodeOTP': (context) => KodeOTP(),
  '/S&KPage': (context) => SyaratDanKetentuan(),
  '/homepage': (context) => authGuardWrapper(HomePage()),
  '/settings': (context) => authGuardWrapper(SettingsPage()),
  '/shops': (context) => authGuardWrapper(const ShopPage()),
  '/analytics': (context) => authGuardWrapper(const AnalyticsPage()),
  '/detailPrefix': (context) => authGuardWrapper(DetailPrefixPage()),
  '/detailNoPrefix': (context) => authGuardWrapper(DetailNoPrefixPage()),
  '/multiSubKategori': (context) =>
      authGuardWrapper(const MultiSubKategoriPage()),
  '/riwayatTransaksi': (context) => authGuardWrapper(RiwayatTransaksiPage()),
  '/struk': (context) => authGuardWrapper(StrukPage(transaksi: null)),
  '/komisiPage': (context) => authGuardWrapper(KomisiPage()),
  '/stastusTukarKomisiPage': (context) =>
      authGuardWrapper(StatusTukarKomisiPage()),
  '/poinPage': (context) => authGuardWrapper(PoinPage()),
  '/detailTukarPoinPage': (context) => authGuardWrapper(DetailTukarPoin()),
  '/verifikasiTukarPoinPage': (context) =>
      authGuardWrapper(VerifikasiTukarPoinPage()),
  '/statusTukarPoinPage': (context) => authGuardWrapper(StatusTukarPoinPage()),
  '/inputNomorTujuan': (context) => authGuardWrapper(InputNomorTujuanAkhir()),
  '/inputNomorFirst': (context) => authGuardWrapper(InputNomorPage()),
  '/inputNomorMid': (context) => authGuardWrapper(InputNomorMidPage()),
  '/detailInfoAkun': (context) => authGuardWrapper(DetailInfoAkun()),
  '/konfirmasiPembayaran': (context) =>
      authGuardWrapper(KonfirmasiPembayaranPage()),
  '/transaksiProses': (context) => authGuardWrapper(TransaksiProsesPage()),
  '/transaksiDetail': (context) =>
      authGuardWrapper(const DetailTransaksiPage()),
  '/speedcashBindingPage': (context) =>
      authGuardWrapper(SpeedcashBindingPage()),
  '/speedcashRegisterPage': (context) =>
      authGuardWrapper(SpeedcashRegisterPage()),
  '/speedcashTopUpPage': (context) =>
      authGuardWrapper(const SpeedcashTopUpPage()),
  '/speedcashTiketTopUpPage': (context) => (const SpeedCashTiketTopUp()),
  '/webView': (context) => authGuardWrapper(WebviewPage(url: '', title: '')),
};
