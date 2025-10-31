import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../../data/services/onboarding_screen_service.dart';
import 'constant_finals.dart';
import '../../data/services/auth_service.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({required this.child, super.key});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _loading = true;
  bool _isLoggedIn = false;
  // Variabel _showOnboarding tidak pernah diubah, mungkin ini bug?
  final bool _showOnboarding = false;
  Timer? _timer;
  final _authService = AuthService();
  final _storageService = OnboardingScreenService();

  @override
  void initState() {
    super.initState();
    // log('[AuthGuard] initState: Scheduling _checkAppFlow.'); // <-- LOG
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAppFlow();
    });
  }

  Future<void> _checkAppFlow() async {
    // log('[AuthGuard] _checkAppFlow: Starting flow check...'); // <-- LOG

    // Pengecekan service akan memunculkan log-nya sendiri
    final onboardingSeen = await _storageService.isOnboardingSeen();
    final loggedIn = await _authService.isLoggedIn();

    // Log hasil pengecekan
    // log(
    //   '[AuthGuard] _checkAppFlow: Values fetched. onboardingSeen: $onboardingSeen, isLoggedIn: $loggedIn',
    // ); // <-- LOG

    if (!onboardingSeen) {
      // log(
      //   '[AuthGuard] Decision: Onboarding NOT seen. Navigating to /onboarding.',
      // ); // <-- LOG
      if (mounted) {
        // Navigasi tidak perlu menunggu, jadi tidak perlu 'await'
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    } else if (loggedIn) {
      // log(
      //   '[AuthGuard] Decision: Onboarding seen AND user logged in. Showing child.',
      // ); // <-- LOG

      // Catatan: Kenapa setOnboardingSeen() dipanggil lagi di sini?
      // Seharusnya tidak perlu karena sudah dicek di 'if' sebelumnya.
      // await _storageService.setOnboardingSeen(); // <-- Saya komentari karena sepertinya tidak perlu

      if (mounted) {
        setState(() {
          _isLoggedIn = true;
          _loading = false;
        });
      }
    } else {
      // log(
      //   '[AuthGuard] Decision: Onboarding seen BUT user NOT logged in. Navigating to /authPage.',
      // ); // <-- LOG
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/authPage');
      }
    }
  }

  @override
  void dispose() {
    // log('[AuthGuard] dispose: Guard is being disposed.'); // <-- LOG
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Log state saat ini setiap kali build dipanggil
    // log(
    //   '[AuthGuard] build: Rendering with state: _loading: $_loading, _isLoggedIn: $_isLoggedIn, _showOnboarding: $_showOnboarding',
    // ); // <-- LOG

    if (_loading) {
      // log('[AuthGuard] build: Showing Loading Indicator (main)'); // <-- LOG
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kOrange)),
      );
    }

    // Kondisi ini (SizedBox.shrink()) mungkin akan menyebabkan layar putih singkat
    // sebelum navigasi ke /authPage selesai.
    if (!_isLoggedIn && !_showOnboarding) {
      // log(
      //   '[AuthGuard] build: Showing SizedBox.shrink() (blank screen)',
      // ); // <-- LOG
      return const SizedBox.shrink();
    }

    // Ternary ini sekarang lebih sederhana
    if (_isLoggedIn) {
      // log('[AuthGuard] build: Showing widget.child (App Content)'); // <-- LOG
      return widget.child;
    } else {
      // Bagian 'else' ini kemungkinan tidak akan pernah tercapai
      // karena sudah ditangani oleh 'if (_loading)' atau 'if (!_isLoggedIn ...)'
      // log('[AuthGuard] build: Showing Loading Indicator (fallback)'); // <-- LOG
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kOrange)),
      );
    }
  }
}
