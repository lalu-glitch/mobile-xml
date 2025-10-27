import 'package:flutter/material.dart';
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
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuth());
  }

  Future<void> _checkAuth() async {
    try {
      final loggedIn = await _authService.isLoggedIn();
      if (mounted) {
        setState(() {
          _isLoggedIn = loggedIn;
          _loading = false;
        });
        if (!loggedIn) {
          Navigator.pushReplacementNamed(context, '/authPage');
        }
      }
    } catch (e) {
      // Fallback ke auth
      if (mounted) {
        setState(() {
          _loading = false;
        });
        Navigator.pushReplacementNamed(context, '/authPage');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || !_isLoggedIn) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kOrange)),
      );
    }
    return widget.child; // MainApp atau protected page
  }
}
