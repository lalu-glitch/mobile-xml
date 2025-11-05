import 'package:flutter/material.dart';
import '../../data/models/speedcash/speedcash_response.dart';
import '../../data/services/speedcash_api_service.dart';

class SpeedcashVM extends ChangeNotifier {
  final SpeedcashApiService _apiService;

  SpeedcashVM({required SpeedcashApiService apiService})
    : _apiService = apiService;

  bool isLoading = false;
  String? error;
  // String? _message;
  // String? get message => _message;
  SpeedcashResponse? response;

  /// Register Speedcash
  // ViewModel
  Future<void> speedcashRegister({
    required String nama,
    required String phone,
    required String email,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await _apiService.speedcashRegister(
        nama: nama,
        phone: phone,
        email: email,
      );

      if (result['success'] == true) {
        final data = result['data'];
        if (data is SpeedcashResponse) {
          response = data;
        } else if (data is Map<String, dynamic>) {
          response = SpeedcashResponse.fromJson(data);
        } else {
          throw Exception("Format data tidak dikenali");
        }
      } else {
        error = result['message']?.toString() ?? "Gagal registrasi Speedcash";
      }
    } catch (e) {
      error = "Gagal registrasi Speedcash: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> speedcashBinding({required String phone}) async {
    isLoading = true;
    error = null;
    response = null;
    notifyListeners();

    try {
      final result = await _apiService.speedcashBinding(phone: phone);

      if (result['success'] == true) {
        final data = result['data'];
        if (data is SpeedcashResponse) {
          response = data;
        } else if (data is Map<String, dynamic>) {
          response = SpeedcashResponse.fromJson(data);
        } else {
          throw Exception("Format data tidak dikenali");
        }
      } else {
        error = result['message']?.toString() ?? "Binding gagal.";
      }
    } catch (e) {
      error = "Error: $e";
    }

    isLoading = false;
    notifyListeners();
  }
}
