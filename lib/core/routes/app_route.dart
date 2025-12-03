import 'package:flutter/material.dart';

import '../../views/auth/pages/lupa_kode_agen.dart';
import '../../views/auth/pages/otp_page.dart';
import '../../views/auth/pages/auth_page.dart';
import '../../initial_page.dart';
import '../../views/auth/pages/SK_page.dart';
import '../../views/input_nomor/pages/input_bn_eu.dart';
import '../../views/input_nomor/pages/input_nomer_awal.dart';
import '../../views/input_nomor/pages/input_nomer_mid.dart';
import '../../views/input_nomor/pages/input_nomor_akhir.dart';
import '../../views/jaringan_mitra/pages/jaringan_mitra_page.dart';
import '../../views/kyc/pages/data_diri/isi_data_diri_onboarding_page.dart';
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
import '../../views/transaksi/pages/cek_transaksi_page.dart';
import '../../views/webview/omni_webview.dart';
import '../helper/onboarding_guard.dart';
import '../../views/speedcash/pages/speedcash_webview.dart';
import '../../views/layanan/noprefix/pages/noprefix_page.dart';
import '../../views/layanan/prefix/pages/prefix_page.dart';
import '../../views/speedcash/pages/speedcash_binding.dart';
import '../../views/speedcash/pages/speedcash_topup_list_bank.dart';
import '../../views/speedcash/pages/speedcash_register.dart';
import '../../views/home/page/home_page.dart';
import '../../views/transaksi/pages/konfirmasi_pembayaran_page.dart';
import '../../views/settings/pages/settings_page.dart';
import '../../views/shops/pages/shop_page.dart';
import '../helper/auth_guard.dart';
import '../../views/struk/pages/struk_page.dart';
import '../../views/transaksi/pages/detail_transaksi_page.dart';
import '../../views/transaksi/pages/transaksi_proses_page.dart';

Widget authGuardWrapper(Widget child) {
  return AuthGuard(child: child);
}

Widget onboardingGuardWrapper(Widget child) {
  return OnboardingGuard(child: child);
}

final Map<String, WidgetBuilder> appRoutes = {
  //ROOT
  '/': (context) =>
      onboardingGuardWrapper(authGuardWrapper(const InitialPage())),
  '/onboarding': (context) => const OnboardingScreen(),

  ///AUTH
  '/lupaKodeAgen': (context) => LupaKodeAgenPage(),
  '/authPage': (context) => AuthPage(),
  '/kodeOTP': (context) => KodeOTP(),
  '/S&KPage': (context) => SyaratDanKetentuan(),

  ///MAIN
  '/homepage': (context) => authGuardWrapper(HomePage()),
  '/settings': (context) => authGuardWrapper(SettingsPage()),
  '/shops': (context) => authGuardWrapper(const ShopPage()),
  '/riwayatTransaksi': (context) => authGuardWrapper(RiwayatTransaksiPage()),

  ///LAYANAN
  '/detailPrefix': (context) => authGuardWrapper(DetailPrefixPage()),
  '/detailNoPrefix': (context) => authGuardWrapper(DetailNoPrefixPage()),
  '/multiSubKategori': (context) =>
      authGuardWrapper(const MultiSubKategoriPage()),
  '/inputNomorTujuan': (context) => authGuardWrapper(InputNomorTujuanAkhir()),
  '/inputNomorFirst': (context) => authGuardWrapper(InputNomorPage()),
  '/inputNomorMid': (context) => authGuardWrapper(InputNomorMidPage()),
  '/inputBNEU': (context) => authGuardWrapper(InputBebasNominalDanEndUser()),

  ///POIN & KOMISI
  '/komisiPage': (context) => authGuardWrapper(KomisiPage()),
  '/statusTukarKomisiPage': (context) =>
      authGuardWrapper(StatusTukarKomisiPage()),
  '/poinPage': (context) => authGuardWrapper(PoinPage()),
  '/detailTukarPoinPage': (context) => authGuardWrapper(DetailTukarPoin()),
  '/verifikasiTukarPoinPage': (context) =>
      authGuardWrapper(VerifikasiTukarPoinPage()),
  '/statusTukarPoinPage': (context) => authGuardWrapper(StatusTukarPoinPage()),

  ///TRANSAKSI
  '/cekTransaksi': (context) => authGuardWrapper(CekTransaksiPage()),
  '/konfirmasiPembayaran': (context) =>
      authGuardWrapper(KonfirmasiPembayaranPage()),
  '/transaksiProses': (context) => authGuardWrapper(TransaksiProsesPage()),
  '/transaksiDetail': (context) =>
      authGuardWrapper(const DetailTransaksiPage()),

  ///TRANSAKSI SPEEDCASH
  '/speedcashBindingPage': (context) =>
      authGuardWrapper(SpeedcashBindingPage()),
  '/speedcashRegisterPage': (context) =>
      authGuardWrapper(SpeedcashRegisterPage()),
  '/speedcashTopUpPage': (context) =>
      authGuardWrapper(const SpeedcashTopUpPage()),
  '/speedcashTiketTopUpPage': (context) => (const SpeedCashTiketTopUp()),
  '/webviewSpeedcash': (context) =>
      authGuardWrapper(SpeedcashWebviewPage(url: '', title: '')),

  ///MENU SETTINGS
  '/jaringanMitra': (context) => authGuardWrapper(JaringanMitraPage()),
  '/KYCPage': (context) => authGuardWrapper(IsiDataDiriOnboardingPage()),

  ///MISCELLANEOUS
  '/struk': (context) => authGuardWrapper(StrukPage(transaksi: null)),
  '/detailInfoAkun': (context) => authGuardWrapper(DetailInfoAkun()),
  '/webview': (context) => authGuardWrapper(OmniWebViewPage()),
};
