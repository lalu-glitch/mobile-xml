import 'dart:async';
import 'package:flutter/material.dart';
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
  Timer? _timer;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuth();

    // Cek login status setiap 2 detik
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      final loggedIn = await _authService.isLoggedIn();
      if (!mounted) return;
      if (!loggedIn) {
        _timer?.cancel();
        Navigator.pushReplacementNamed(context, '/sendOtp');
      }
    });
  }

  Future<void> _checkAuth() async {
    final loggedIn = await _authService.isLoggedIn();

    if (!mounted) return;

    if (!loggedIn) {
      Navigator.pushReplacementNamed(context, '/sendOtp');
    } else {
      setState(() {
        _isLoggedIn = true;
        _loading = false;
      });
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_isLoggedIn) {
      return const SizedBox.shrink();
    }
    return widget.child;
  }
}
