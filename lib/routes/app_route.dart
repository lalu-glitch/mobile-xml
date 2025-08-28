import 'package:flutter/material.dart';

import '../auth/send_otp.dart';
import '../auth/verify_otp.dart';
import '../main_page.dart';
import '../views/analytics_page.dart';
import '../views/detail_input_tujuan.dart';
import '../views/detail_noprefix_page.dart';
import '../views/detail_prefix_page.dart';
import '../views/home_page.dart';
import '../views/konfirmasi_page.dart';
import '../views/settings_page.dart';
import '../views/shops_page.dart';
import '../services/auth_guard.dart';
import '../views/transaksi_detail_page.dart';
import '../views/transaksi_proses_page.dart'; // Pastikan import AuthGuard

Widget authGuardWrapper(Widget child) {
  return AuthGuard(child: child);
}

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => authGuardWrapper(
    const MainPage(),
  ), // kalau kamu pisah main page seperti sebelumnya
  '/sendOtp': (context) => (SendOtpPage()),
  '/verifyOtp': (context) => (VerifyOtpPage()),
  '/homepage': (context) => authGuardWrapper(HomePage()),
  '/settings': (context) => authGuardWrapper(const SettingsPage()),
  '/shops': (context) => authGuardWrapper(const ShopsPage()),
  '/analytics': (context) => authGuardWrapper(const AnalyticsPage()),
  '/detailPrefix': (context) => authGuardWrapper(DetailPrefixPage()),
  '/detailNoPrefix': (context) => authGuardWrapper(DetailNoPrefixPage()),
  '/inputNomorTujuan': (context) => authGuardWrapper(
    InputNomorTujuanPage(kode_produk: '', namaProduk: '', total: ''),
  ),
  '/konfirmasiPembayaran': (context) => authGuardWrapper(
    KonfirmasiPembayaranPage(
      tujuan: '', // placeholder, nanti dikirim via arguments
      kode_produk: '',
      namaProduk: '',
      total: 0,
    ),
  ),
  '/transaksiProses': (context) =>
      authGuardWrapper(TransaksiProsesPage(tujuan: '', kode_produk: '')),
  '/transaksiDetail': (context) =>
      authGuardWrapper(const DetailTransaksiPage()), // format sama
};
