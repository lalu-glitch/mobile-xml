import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/helper/constant_finals.dart';
import '../../core/helper/date_extension.dart';
import '../models/speedcash/speedcash_binding_model.dart';
import '../models/speedcash/speedcash_konfirmasi_transaksi_model.dart';
import '../models/speedcash/speedcash_list_bank_model.dart';
import '../models/speedcash/speedcash_payment_transaksi_model.dart';
import '../models/speedcash/speedcash_register_model.dart';
import '../models/speedcash/speedcash_request_topup_model.dart';
import '../models/speedcash/speedcash_topup_guide_model.dart';
import '../models/speedcash/speedcash_unbind_model.dart';
import 'auth_service.dart';

class SpeedcashApiService {
  final AuthService authService;

  SpeedcashApiService({AuthService? authService})
    : authService = authService ?? AuthService();

  final String clientId = dotenv.env['CLIENT_ID_SPEEDCASH'] ?? '';

  String createSign({
    required String httpMethod,
    required String endpoint,
    required String timestamp,
  }) {
    final stringToSign = '$httpMethod:$endpoint:$timestamp';
    final key = utf8.encode(clientId);
    final bytes = utf8.encode(stringToSign);
    final hmac = crypto.Hmac(crypto.sha512, key);
    final digest = hmac.convert(bytes);
    return base64.encode(digest.bytes);
  }

  Map<String, String> createHeaders(String endPoint, String method) {
    final timeStamp = DateTime.now();
    final formatted = timeStamp.toIso8601WithOffset();

    final token = createSign(
      httpMethod: method,
      endpoint: endPoint,
      timestamp: formatted,
    );

    return {
      'X-TIMESTAMP': formatted,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<SpeedcashRegisterModel> speedcashRegister({
    required String nama,
    required String phone,
    required String email,
    required String kodeReseller,
  }) async {
    try {
      final response = await authService.dio.post(
        "$baseURLIntegration/speedcash/create_account",
        options: Options(
          headers: createHeaders('/api/speedcash/create_account', 'POST'),
        ),
        data: {
          "nama": nama,
          "phone": phone,
          "email": email,
          "kode_reseller": kodeReseller,
        },
      );
      if (response.statusCode == 200) {
        return SpeedcashRegisterModel.fromJson(response.data);
      } else {
        throw Exception(
          "Gagal binding Speedcash. Status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map<String, dynamic>)
          ? data['message'] ?? "Terjadi kesalahan server"
          : e.message ?? "Koneksi bermasalah";
      log("DioException: $msg");
      return SpeedcashRegisterModel.error(msg);
    } catch (e) {
      return SpeedcashRegisterModel.error(e.toString());
    }
  }

  Future<SpeedcashBindingModel> speedcashBinding(
    String kodeReseller,
    String phone,
  ) async {
    try {
      final response = await authService.dio.post(
        "$baseURLIntegration/speedcash/bind_account",
        options: Options(
          headers: createHeaders('/api/speedcash/bind_account', 'POST'),
        ),
        data: {"kode_reseller": kodeReseller, "phone": phone},
      );

      if (response.statusCode == 200) {
        return SpeedcashBindingModel.fromJson(response.data);
      } else {
        throw Exception(
          "Gagal binding Speedcash. Status: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      final data = e.response?.data;

      final msg = (data is Map<String, dynamic>)
          ? data['message'] ?? "Terjadi kesalahan server"
          : e.message ?? "Koneksi bermasalah";
      log("DioException: $msg");
      return SpeedcashBindingModel.error(msg);
    } catch (e) {
      return SpeedcashBindingModel.error(e.toString());
    }
  }

  Future<SpeedcashUnbindModel> speedcashUnbind(String kodeReseller) async {
    try {
      final response = await authService.dio.post(
        "$baseURLIntegration/speedcash/unbind_account",
        options: Options(
          headers: createHeaders('/api/speedcash/unbind_account', 'POST'),
        ),
        data: {"kode_reseller": kodeReseller},
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
      log("DioException: $apiMessage");
      throw Exception(apiMessage);
    } catch (e) {
      log("Exception: $e");
      throw Exception(e.toString());
    }
  }

  Future<DataBank> listOfBanks(String kodeReseller) async {
    try {
      final response = await authService.dio.get(
        '$baseURLIntegration/speedcash/list-bank/$kodeReseller',
        options: Options(
          headers: createHeaders(
            '/api/speedcash/list-bank/$kodeReseller',
            'GET',
          ),
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
          headers: createHeaders(
            '/api/speedcash/guide-topup?kode_reseller=$kodeReseller&bank=$bank',
            'GET',
          ),
        ),
      );
      if (response.statusCode == 200) {
        return GuideTopUpModel.fromJson(response.data);
      } else {
        throw Exception("Gagal, Status Server: ${response.statusCode}");
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

  Future<RequestTopUpModel> requestTopUp(
    String kodeReseller,
    int nominal,
    String bank,
  ) async {
    try {
      final response = await authService.dio.post(
        '$baseURLIntegration/speedcash/request-topup',
        options: Options(
          headers: createHeaders('/api/speedcash/request-topup', 'POST'),
        ),
        data: {"kode_reseller": kodeReseller, "nominal": nominal, "bank": bank},
      );
      if (response.statusCode == 200) {
        return RequestTopUpModel.fromJson(response.data);
      } else {
        throw Exception("Gagal, Status Server: ${response.statusCode}");
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

  Future<SpeedcashKonfirmasiTransaksiModel> konfirmasiTransaksiSpeedcash(
    String kodeReseller,
    String kodeProduk,
    String tujuan,
    int qty,
    String endUser,
    String subProduk,
    int hargaSubProduk,
  ) async {
    try {
      final response = await authService.dio.post(
        '$baseURLIntegration/speedcash/confirm',
        options: Options(
          headers: createHeaders('/api/speedcash/confirm', 'POST'),
        ),
        data: {
          "kode_reseller": kodeReseller,
          "kode_produk": kodeProduk,
          "tujuan": tujuan,
          "qty": qty,
          "enduser": endUser,
          "sub_produk": subProduk,
          "harga_sub_produk": hargaSubProduk,
        },
      );
      if (response.statusCode == 200) {
        return SpeedcashKonfirmasiTransaksiModel.fromJson(response.data);
      } else {
        throw Exception("Gagal, Status Server ${response.statusCode}");
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? (e.response?.data["message"] ?? "Terjadi kesalahan server")
          : e.message;
      log("DioException: $apiMessage");
      throw Exception(apiMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<SpeedcashPaymentTransaksiModel> pembayaranTransaksiSpeedcash(
    String kodeReseller,
    String originPartnerReffNumber,
  ) async {
    try {
      final response = await authService.dio.post(
        '$baseURLIntegration/speedcash/payment',
        options: Options(
          headers: createHeaders('/api/speedcash/payment', 'POST'),
        ),
        data: {
          "kode_reseller": kodeReseller,
          "originalPartnerReferenceNo": originPartnerReffNumber,
        },
      );
      log('$response');
      if (response.statusCode == 200) {
        return SpeedcashPaymentTransaksiModel.fromJson(response.data);
      } else {
        throw Exception("Gagal, Status Server ${response.statusCode}");
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? (e.response?.data["message"] ?? "Terjadi kesalahan server")
          : e.message;
      log("DioException: $apiMessage");
      throw Exception(apiMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
