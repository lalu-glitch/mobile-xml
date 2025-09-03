import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../models/speedcash/speedcash_response.dart';
import 'auth_service.dart';
import 'package:logger/logger.dart';

class SpeedcashApiService {
  final AuthService authService;
  final Logger logger;

  SpeedcashApiService({AuthService? authService, Logger? logger})
    : authService = authService ?? AuthService(),
      logger = logger ?? Logger();

  Future<Map<String, dynamic>> speedcashRegister({
    required String nama,
    required String phone,
    required String email,
  }) async {
    try {
      final response = await authService.dio.post(
        "${AppConfig.baseUrlApp}/speedcash/create_account",
        data: {"name": nama, "phone": phone, "email": email},
      );

      if (response.statusCode == 200) {
        final jsonData = Map<String, dynamic>.from(response.data);
        return {
          "success": true,
          "data": SpeedcashResponse.fromJson(jsonData),
          "message": jsonData["responseMessage"] ?? "Berhasil daftar speedcash",
        };
      } else {
        return {
          "success": false,
          "data": null,
          "message": "Gagal daftar speedcash. Status: ${response.statusCode}",
        };
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? e.response?.data["message"]["responseMessage"] ??
                "Terjadi kesalahan server"
          : e.message;
      return {"success": false, "data": null, "message": apiMessage};
    } catch (e) {
      return {"success": false, "data": null, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> speedcashBinding({
    required String phone,
    required String merchantId,
  }) async {
    try {
      final response = await authService.dio.post(
        "${AppConfig.baseUrlApp}/speedcash/account_binding",
        data: {"phone": phone, "merchantId": merchantId},
      );

      if (response.statusCode == 200) {
        final jsonData = Map<String, dynamic>.from(response.data);
        return {
          "success": true,
          "data": SpeedcashResponse.fromJson(jsonData),
          "message":
              jsonData["responseMessage"] ?? "Berhasil binding Speedcash",
        };
      } else {
        return {
          "success": false,
          "data": null,
          "message": "Gagal binding Speedcash. Status: ${response.statusCode}",
        };
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? e.response?.data["message"]["responseMessage"] ??
                "Terjadi kesalahan server"
          : e.message;
      return {"success": false, "data": null, "message": apiMessage};
    } catch (e) {
      return {"success": false, "data": null, "message": e.toString()};
    }
  }
}
