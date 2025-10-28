import 'package:flutter/material.dart';

import 'constant_finals.dart';
import '../../data/services/onboarding_screen_service.dart';

class OnboardingGuard extends StatefulWidget {
  final Widget child;

  const OnboardingGuard({required this.child, super.key});

  @override
  State<OnboardingGuard> createState() => _OnboardingGuardState();
}

class _OnboardingGuardState extends State<OnboardingGuard> {
  bool _loading = true;
  bool _navigated = false;
  final _storageService = OnboardingScreenService();

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    try {
      final onboardingSeen = await _storageService.isOnboardingSeen();
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      if (!onboardingSeen && !_navigated) {
        _navigated = true;
        // schedule navigation after current microtask/frame
        Future.delayed(Duration.zero, () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/onboarding');
          }
        });
      }
      // jika sudah seen -> biarkan widget.child tampil
    } catch (e) {
      if (!mounted) return;
      if (!_navigated) {
        _navigated = true;
        Future.delayed(Duration.zero, () {
          if (mounted) Navigator.pushReplacementNamed(context, '/onboarding');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kOrange)),
      );
    }
    return widget.child;
  }
}
