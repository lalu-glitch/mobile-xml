import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreenService {
  final String _onBoardingKey = 'onboarding_seen';

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onBoardingKey, true);
  }

  Future<bool> isOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onBoardingKey) ?? false;
  }
}
