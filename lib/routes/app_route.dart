import 'package:flutter/material.dart';

import '../auth/send_otp.dart';
import '../auth/verify_otp.dart';
import '../main_page.dart';
import '../views/analytics_page.dart';
import '../views/detail_noprefix_page.dart';
import '../views/home_page.dart';
import '../views/settings_page.dart';
import '../views/shops_page.dart';
import '../services/auth_guard.dart'; // Pastikan import AuthGuard

Widget authGuardWrapper(Widget child) {
  return AuthGuard(child: child);
}

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => authGuardWrapper(
    const MainPage(),
  ), // kalau kamu pisah main page seperti sebelumnya
  '/homepage': (context) => authGuardWrapper(HomePage()),
  '/settings': (context) => authGuardWrapper(const SettingsPage()),
  '/shops': (context) => authGuardWrapper(const ShopsPage()),
  '/analytics': (context) => authGuardWrapper(const AnalyticsPage()),
  '/detailNoPrefix': (context) => authGuardWrapper(DetailNoPrefixPage()),
  '/sendOtp': (context) => (SendOtpPage()),
  '/verifyOtp': (context) => (VerifyOtpPage()),
};
