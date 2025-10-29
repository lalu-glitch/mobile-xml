import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingScreenService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _onBoardingKey = 'onboarding_seen';

  Future<void> setOnboardingSeen() async {
    log('[OnboardingService] Setting onboarding as seen...'); // <-- LOG
    await _storage.write(key: _onBoardingKey, value: 'true');
    log('[OnboardingService] Onboarding successfully set.'); // <-- LOG
  }

  Future<bool> isOnboardingSeen() async {
    final value = await _storage.read(key: _onBoardingKey);
    // Log di bawah ini sudah ada dari kode Anda
    log('[OnboardingService] isOnboardingSeen check: $value');
    return value == 'true';
  }
}
