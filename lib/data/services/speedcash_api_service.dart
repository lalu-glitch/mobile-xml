import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/helper/constant_finals.dart';
import '../models/speedcash/speedcash_list_bank.dart';
import '../models/speedcash/speedcash_response.dart';
import '../models/speedcash/speedcash_topup_guide.dart';
import '../models/speedcash/speedcash_unbind.dart';
import 'auth_service.dart';
import 'package:logger/logger.dart';

class SpeedcashApiService {
  final AuthService authService;
  final Logger logger;

  SpeedcashApiService({AuthService? authService, Logger? logger})
    : authService = authService ?? AuthService(),
      logger = logger ?? Logger();

  final String _basicAuthSpeedcashHeader =
      "Basic ${base64Encode(utf8.encode("${dotenv.env['BASIC_USER_SPEEDCASH']}:${dotenv.env['BASIC_PASS_SPEEDCASH']}"))}";

  Future<Map<String, dynamic>> speedcashRegister({
    required String nama,
    required String phone,
    required String email,
  }) async {
    try {
      final response = await authService.dio.post(
        "$baseURLIntegration/speedcash/create_account",
        options: Options(
          headers: {
            "Authorization": _basicAuthSpeedcashHeader,
            "Content-Type": "application/json",
          },
        ),
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
        "$baseURLIntegration/speedcash/account_binding",
        options: Options(
          headers: {
            "Authorization": _basicAuthSpeedcashHeader,
            "Content-Type": "application/json",
          },
        ),
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

  Future<SpeedcashUnbindModel> speedcashUnbind() async {
    try {
      final response = await authService.dio.post(
        "$baseURLIntegration/speedcash/unbind_account",
        options: Options(
          headers: {
            "Authorization": _basicAuthSpeedcashHeader,
            "Content-Type": "application/json",
          },
        ),
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

  Future<DataBank> listOfBanks(String kodeReseller) async {
    try {
      final response = await authService.dio.get(
        '$baseURLIntegration/speedcash/list-bank/$kodeReseller',
        options: Options(
          headers: {
            "Authorization": _basicAuthSpeedcashHeader,
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200) {
        return DataBank.fromJson(response.data["data"]);
      } else {
        throw Exception(
          "Gagal mendapatkan list Bank. Status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? (e.response?.data["message"] ?? "Terjadi kesalahan server")
          : e.message;
      log("DioException: $apiMessage");
      throw Exception(apiMessage);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<GuideTopUpModel> topUpGuide(String kodeReseller, String bank) async {
    try {
      final response = await authService.dio.get(
        '$baseURLIntegration/speedcash/guide-topup?kode_reseller=$kodeReseller&bank=$bank',
        options: Options(
          headers: {
            "Authorization": _basicAuthSpeedcashHeader,
            "Content-Type": "application/json",
          },
        ),
      );
      log('$response');
      if (response.statusCode == 200) {
        return GuideTopUpModel.fromJson(response.data);
      } else {
        throw Exception(
          "Gagal mendapatkan panduan topup. Status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? (e.response?.data["message"] ?? "Terjadi kesalahan server")
          : e.message;
      log("DioException: $apiMessage");
      throw Exception(apiMessage);
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }
}
