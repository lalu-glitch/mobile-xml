import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_launcher_icons/logger.dart';
import '../config/app_config.dart';
import '../models/user_balance.dart';
import '../models/icon_data.dart';
import 'auth_service.dart';
import 'package:logger/logger.dart';

class ApiService {
  final authService = AuthService();

  /// Ambil saldo user
  Future<UserBalance> fetchUserBalance() async {
    try {
      final response = await authService.dio.get(
        "${AppConfig.baseUrlApp}/user_dummy",
      );
      final logger = Logger();

      logger.t("Trace log");

      logger.d("Debug log");

      logger.i("Info log");

      logger.w("Warning log");

      // logger.e("Error log", error: 'Test Error');

      if (response.statusCode == 200) {
        return UserBalance.fromJson(response.data);
      } else {
        throw Exception("Failed to load user balance");
      }
    } on DioException catch (e) {
      throw Exception(
        "Error fetchUserBalance: ${e.response?.data ?? e.message}",
      );
    }
  }

  /// Ambil icon dengan kategori (pulsa, ewallet, token, dll)
  Future<Map<String, List<IconItem>>> fetchIcons() async {
    try {
      final response = await authService.dio.get(
        "${AppConfig.baseUrlApp}/list-icon",
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;

        if (jsonData is Map) {
          final Map<String, List<IconItem>> parsedData = {};

          jsonData.forEach((key, value) {
            if (value is List) {
              parsedData[key] = value
                  .map((item) => IconItem.fromJson(item))
                  .toList();
            }
          });

          return parsedData;
        } else {
          throw Exception("Invalid JSON format for icons");
        }
      } else {
        throw Exception("Failed to load icons. Status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("Error fetchIcons: ${e.response?.data ?? e.message}");
    }
  }
}
