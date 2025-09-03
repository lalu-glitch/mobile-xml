import 'package:flutter/material.dart';
import '../../services/speedcash_api_service.dart';

class SpeedcashRegisterVM extends ChangeNotifier {
  final SpeedcashApiService _apiService;

  SpeedcashRegisterVM({required SpeedcashApiService apiService})
    : _apiService = apiService;

  bool isLoading = false;

  /// Register Speedcash
  Future<Map<String, dynamic>> register({
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
}
