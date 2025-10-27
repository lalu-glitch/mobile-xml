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
  final _storageService = OnboardingScreenService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOnboarding());
  }

  Future<void> _checkOnboarding() async {
    try {
      final onboardingSeen = await _storageService.isOnboardingSeen();
      if (mounted) {
        setState(() {
          _loading = false;
        });
        if (!onboardingSeen) {
          // Navigasi ke onboarding, lalu di akhir onboarding set seen dan pop/replace ke child
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
        // Jika seen, tampilkan child (tidak perlu setState lagi, build akan handle)
      }
    } catch (e) {
      // Fallback: Asumsikan belum seen
      if (mounted) Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kOrange)),
      );
    }
    // Selalu return child setelah check—navigasi handle sisanya
    return widget.child;
  }
}
