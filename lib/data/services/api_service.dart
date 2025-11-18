import 'dart:developer';

import 'package:android_id/android_id.dart';
import 'package:dio/dio.dart';
import '../../core/helper/constant_finals.dart';
import '../models/layanan/layanan_model.dart';
import '../models/produk/provider_kartu.dart';
import '../models/transaksi/status_transaksi.dart';
import '../models/transaksi/riwayat_transaksi.dart';
import '../models/transaksi/transaksi_response.dart';
import '../models/user/edit_info_akun.dart';
import '../models/user/info_akun.dart';
import '../models/user/user_balance.dart';
import 'auth_service.dart';
import 'package:logger/logger.dart';

class ApiService {
  final AuthService authService;
  final Logger logger;

  ApiService({AuthService? authService, Logger? logger})
    : authService = authService ?? AuthService(),
      logger = logger ?? Logger();

  Future<String> loadDeviceId() async {
    try {
      const androidIdPlugin = AndroidId();
      final androidId = await androidIdPlugin.getId();
      return androidId ?? "unknown-android-id";
    } catch (_) {
      return "unknown-device";
    }
  }

  /// Ambil saldo user
  Future<UserBalance> fetchUserBalance() async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.get(
        "$baseURL/user/balance",
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
      );
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
  Future<IconResponse> fetchIcons() async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.get(
        baseURLWEB,
        options: Options(
          headers: {
            "Authorization": authService.basicAuthHeader,
            "x-device-id": "android-$deviceID",
          },
        ),
      );
      if (response.statusCode == 200) {
        return IconResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to load icons. Status: ${response.statusCode}");
      }
    } on DioException catch (e) {
      log("Error fetchIcons: ${e.response?.data ?? e.message}");
      throw Exception("Error fetchIcons: ${e.response?.data ?? e.message}");
    }
  }

  /// Ambil provider berdasarkan kategori dan tujuan
  Future<List<ProviderKartu>> fetchProviders(
    String category,
    String tujuan,
  ) async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.post(
        "$baseURL/oto/all_produk/$category",
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
        data: {"tujuan": tujuan},
      );
      final jsonData = Map<String, dynamic>.from(response.data);
      if (response.statusCode == 200 && jsonData['success'] == true) {
        final providers = (jsonData['data'] as List? ?? [])
            .map(
              (item) => ProviderKartu.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
        return providers;
      }

      throw Exception("Gagal memuat provider. Status: ${response.statusCode}");
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? e.response?.data["message"] ?? "Terjadi kesalahan pada server."
          : e.message;
      throw Exception(apiMessage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ProviderKartu>> fetchProvidersPrefix(
    String category,
    String tujuan,
  ) async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.post(
        "$baseURL/oto/all_produk_prefix/$category",
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
        data: {"tujuan": tujuan},
      );
      log(response.data.toString());
      final jsonData = Map<String, dynamic>.from(response.data);
      if (response.statusCode == 200 && jsonData['success'] == true) {
        return (jsonData['data'] as List? ?? [])
            .map(
              (item) => ProviderKartu.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();
      }

      throw Exception(
        jsonData["message"] ??
            "Gagal memuat provider prefix. Status: ${response.statusCode}",
      );
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? e.response?.data["message"] ?? "Terjadi kesalahan pada server."
          : e.message;
      throw Exception(apiMessage);
    }
  }

  /// Proses transaksi
  Future<Map<String, dynamic>> prosesTransaksi(
    String tujuan,
    String kodeProduk,
    String kodeDompet,
  ) async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.post(
        "$baseURL/transaksi",
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
        data: {
          "tujuan": tujuan,
          "kode_produk": kodeProduk,
          "kode_dompet": kodeDompet,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = Map<String, dynamic>.from(response.data);
        return {
          "success": jsonData["success"] ?? false,
          "data": TransaksiResponseModel.fromJson(jsonData),
          "message": jsonData["message"] ?? "Berhasil memproses transaksi",
        };
      } else {
        return {
          "success": false,
          "data": null,
          "message":
              "Gagal memproses transaksi. Status: ${response.statusCode}",
        };
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? e.response?.data["message"] ?? "Terjadi kesalahan server"
          : e.message;
      return {"success": false, "data": null, "message": apiMessage};
    } catch (e) {
      return {"success": false, "data": null, "message": e.toString()};
    }
  }

  /// Cek status transaksi by kode_inbox
  Future<Map<String, dynamic>> getStatusByInbox(int kodeInbox) async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.post(
        "$baseURL/trx_by_inbox/$kodeInbox",
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
      );

      if (response.statusCode == 200) {
        final jsonData = Map<String, dynamic>.from(response.data);
        return {
          "success": true,
          "data": StatusTransaksiModel.fromJson(jsonData),
          "message": "Berhasil mendapatkan status transaksi",
        };
      } else {
        return {
          "success": false,
          "data": null,
          "message": "Gagal mendapatkan status. Status: ${response.statusCode}",
        };
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? e.response?.data["message"] ?? "Terjadi kesalahan server"
          : e.message;
      return {"success": false, "data": null, "message": apiMessage};
    } catch (e) {
      return {"success": false, "data": null, "message": e.toString()};
    }
  }

  //HISTORY TRANSAKSI
  Future<RiwayatTransaksiResponseModel?> fetchRiwayat({
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.get(
        "$baseURL/history_transaksi",
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
        queryParameters: {"page": page, "limit": limit},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(
          response.data,
        );
        return RiwayatTransaksiResponseModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        if (data.containsKey('message')) {
          throw Exception(data['message']);
        }
      }
      throw Exception("Error fetchHistory: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> historyDetail(String kodeKode) async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.post(
        "$baseURL/trx_by_kode/$kodeKode",
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
      );
      if (response.statusCode == 200) {
        final jsonData = Map<String, dynamic>.from(response.data);
        return {
          "success": true,
          "data": jsonData,
          "message": "Berhasil mendapatkan detail history transaksi",
        };
      } else {
        return {
          "success": false,
          "data": null,
          "message":
              "Gagal mendapatkan detail history. Status: ${response.statusCode}",
        };
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? e.response?.data["message"] ?? "Terjadi kesalahan server"
          : e.message;
      return {"success": false, "data": null, "message": apiMessage};
    } catch (e) {
      return {"success": false, "data": null, "message": e.toString()};
    }
  }

  //INFO AKUN
  Future<InfoAkunModel> infoAkun() async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.get(
        "$baseURL/user/info",
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
      );
      if (response.statusCode == 200) {
        return InfoAkunModel.fromJson(response.data);
      } else {
        throw Exception(
          "Gagal mendapatkan info akun ${response.statusMessage}",
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

  //EDIT USER
  Future<UserEditModel> editMarkupRef(int value) async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.post(
        "$baseURL/user/ganti_markup_ref",
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
        data: {"markup_referral": value},
      );

      if (response.statusCode == 200) {
        return UserEditModel.fromJson(response.data);
      } else {
        throw Exception(
          "Gagal mengubah markup referral: ${response.statusMessage}",
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

  Future<UserEditModel> editKodeRef(String value) async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.post(
        '$baseURL/user/ganti_kode_ref',
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
        data: {"kode_referral": value},
      );
      if (response.statusCode == 200) {
        return UserEditModel.fromJson(response.data);
      } else {
        throw Exception(
          "Gagal mengubah kode referral: ${response.statusMessage}",
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
