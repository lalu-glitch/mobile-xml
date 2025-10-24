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
    // _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
    //   if (!mounted) return;
    //   final loggedIn = await _authService.isLoggedIn();
    //   if (!loggedIn && !_showOnboarding) {
    //     // Flag ini sekarang di-set correctly
    //     Navigator.pushReplacementNamed(context, '/authPage');
    //   }
    // });
  }

  Future<void> _checkAppFlow() async {
    // FIX: Sekarang dipanggil post-frame
    final onboardingSeen = await _storageService.isOnboardingSeen();
    final loggedIn = await _authService.isLoggedIn();

    if (!onboardingSeen) {
      // Jika onboarding belum pernah dilihat, arahkan ke onboarding.
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    } else if (loggedIn) {
      // Jika onboarding sudah dilihat DAN pengguna sudah login,
      // tandai onboarding sebagai selesai (untuk jaga-jaga) dan tampilkan child.
      await _storageService.setOnboardingSeen();
      if (mounted) {
        setState(() {
          _isLoggedIn = true; // Tampilkan child (halaman utama)
          _loading = false; // Sembunyikan loading indicator
        });
      }
    } else {
      // Jika onboarding sudah dilihat TAPI pengguna belum login, arahkan ke halaman auth.
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/authPage');
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
    // Jika sudah login, tampilkan halaman yang diproteksi (MainPage).
    // Jika tidak, loading screen akan terus tampil sampai navigasi terjadi.
    return _isLoggedIn
        ? widget.child
        : const Scaffold(
            body: Center(child: CircularProgressIndicator(color: kOrange)),
          );
  }
}
