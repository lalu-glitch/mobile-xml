import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xmlapp/data/services/onboarding_screen_service.dart';
import '../../core/helper/constant_finals.dart';
import 'auth_service.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({required this.child, super.key});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _loading = true;
  bool _isLoggedIn = false;
  bool _showOnboarding = false;
  Timer? _timer;
  final _authService = AuthService();
  final _storageService = OnboardingScreenService();

  @override
  void initState() {
    super.initState();
    // FIX: Hapus _checkAppFlow() dari initState, pindah ke post-frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAppFlow();
    });

    // Timer tetap, tapi sekarang navigasi awal sudah deferred
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!mounted) return;
      final loggedIn = await _authService.isLoggedIn();
      if (!loggedIn && !_showOnboarding) {
        // Flag ini sekarang di-set correctly
        Navigator.pushReplacementNamed(context, '/authPage');
      }
    });
  }

  Future<void> _checkAppFlow() async {
    // FIX: Sekarang dipanggil post-frame
    final onboardingSeen = await _storageService.isOnboardingSeen();

    if (!onboardingSeen) {
      setState(() {
        // FIX: Set flag sebelum navigasi
        _showOnboarding = true;
      });
      if (!mounted) return;
      // FIX: Gunakan post-frame lagi untuk navigasi, double-safe
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      });
      return;
    }

    final loggedIn = await _authService.isLoggedIn();
    if (!mounted) return;

    if (!loggedIn) {
      // FIX: Defer juga untuk konsistensi
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/authPage');
        }
      });
    } else {
      if (mounted) {
        setState(() {
          _isLoggedIn = true;
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kOrange)),
      );
    }
    if (!_isLoggedIn && !_showOnboarding) {
      // FIX: Tambah check _showOnboarding di build
      return const SizedBox.shrink();
    }
    return widget.child;
  }
}
