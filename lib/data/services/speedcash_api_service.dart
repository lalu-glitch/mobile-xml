import 'package:dio/dio.dart';
import '../../core/constant_finals.dart';
import '../models/speedcash/speedcash_response.dart';
import '../models/speedcash/speedcash_unbind.dart';
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
        "$baseURL/speedcash/create_account",
        data: {"nama": nama, "phone": phone, "email": email},
      );

      if (response.statusCode == 200) {
        final jsonData = Map<String, dynamic>.from(response.data);

        final parsed = SpeedcashResponse.fromJson(jsonData);

        return {
          "success": parsed.success,
          "data": parsed,
          "message": parsed.success
              ? "Berhasil daftar speedcash"
              : "Gagal daftar speedcash",
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
          ? (e.response?.data["message"] ?? "Terjadi kesalahan server")
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
        "$baseURL/speedcash/account_binding",
        data: {"phone": phone, "merchantId": merchantId},
      );

      if (response.statusCode == 200) {
        final jsonData = Map<String, dynamic>.from(response.data);

        final parsed = SpeedcashResponse.fromJson(jsonData);

        return {
          "success": parsed.success,
          "data": parsed,
          "message": parsed.success
              ? "Berhasil binding Speedcash"
              : "Gagal binding Speedcash",
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
          ? (e.response?.data["message"] ?? "Terjadi kesalahan server")
          : e.message;
      return {"success": false, "data": null, "message": apiMessage};
    } catch (e) {
      return {"success": false, "data": null, "message": e.toString()};
    }
  }

  /// Udah Work tapi pusing bacanya
  // Future<Map<String, dynamic>> speedcashUnbind() async {
  //   try {
  //     final response = await authService.dio.post(
  //       "$baseURL/speedcash/unbind_account",
  //       // Jika ada body data, tambahkan di sini, e.g., data: {"phone": phone},
  //     );

  //     if (response.statusCode == 200) {
  //       final jsonData = Map<String, dynamic>.from(response.data);
  //       final parsed = SpeedcashUnbindModel.fromJson(jsonData);
  //       return {
  //         "success": parsed.success,
  //         "data": parsed,
  //         "message": parsed.success ? parsed.message : "Gagal unbind Speedcash",
  //       };
  //     } else {
  //       return {
  //         "success": false,
  //         "data": null,
  //         "message": "Gagal unbind Speedcash. Status: ${response.statusCode}",
  //       };
  //     }
  //   } on DioException catch (e) {
  //     final apiMessage = e.response?.data is Map
  //         ? (e.response?.data["message"] ?? "Terjadi kesalahan server")
  //         : e.message;
  //     return {"success": false, "data": null, "message": apiMessage};
  //   } catch (e) {
  //     return {"success": false, "data": null, "message": e.toString()};
  //   }
  // }

  //penggantinya
  Future<SpeedcashUnbindModel> speedcashUnbind() async {
    try {
      final response = await authService.dio.post(
        "$baseURL/speedcash/unbind_account",
      );
      if (response.statusCode == 200) {
        return SpeedcashUnbindModel.fromJson(
          Map<String, dynamic>.from(response.data),
        );
      } else {
        throw Exception(
          "Gagal unbind Speedcash. Status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? (e.response?.data["message"] ?? "Terjadi kesalahan server")
          : e.message;
      logger.e("DioException: $apiMessage");
      throw Exception(apiMessage);
    } catch (e) {
      logger.e("Exception: $e");
      throw Exception(e.toString());
    }
  }
}
