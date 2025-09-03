import 'package:flutter/material.dart';
import '../../services/speedcash_api_service.dart';

class SpeedcashVM extends ChangeNotifier {
  final SpeedcashApiService _apiService;

  SpeedcashVM({required SpeedcashApiService apiService})
    : _apiService = apiService;

  bool isLoading = false;

  /// Register Speedcash
  Future<Map<String, dynamic>> speedcashRegister({
    required String nama,
    required String phone,
    required String email,
  }) async {
    isLoading = true;
    notifyListeners();

    final result = await _apiService.speedcashRegister(
      nama: nama,
      phone: phone,
      email: email,
    );

    isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> speedcashBinding({
    required String phone,
    required String merchantId,
  }) async {
    isLoading = true;
    notifyListeners();

    final result = await _apiService.speedcashBinding(
      phone: phone,
      merchantId: merchantId,
    );

    isLoading = false;
    notifyListeners();

    return result;
  }
}
