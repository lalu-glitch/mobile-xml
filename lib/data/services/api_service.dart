import 'dart:developer';

import 'package:android_id/android_id.dart';
import 'package:dio/dio.dart';
import '../../core/helper/constant_finals.dart';
import '../models/layanan/layanan_model.dart';
import '../models/mitra/mitra_model.dart';
import '../models/mitra/mitra_stats_model.dart';
import '../models/produk/provider_kartu_model.dart';
import '../models/transaksi/status_transaksi_model.dart';
import '../models/transaksi/riwayat_transaksi_model.dart';
import '../models/user/edit_info_akun_model.dart';
import '../models/user/info_akun_model.dart';
import '../models/user/user_balance_model.dart';
import 'auth_service.dart';

class ApiService {
  final AuthService authService;

  ApiService({AuthService? authService})
    : authService = authService ?? AuthService();

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

  /// Ambil item promo dan layanan
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
  Future<List<Provider>> fetchProviders(String category, String tujuan) async {
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
            .map((item) => Provider.fromJson(Map<String, dynamic>.from(item)))
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

  Future<List<Provider>> fetchProvidersPrefix(
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
      final jsonData = Map<String, dynamic>.from(response.data);
      if (response.statusCode == 200 && jsonData['success'] == true) {
        return (jsonData['data'] as List? ?? [])
            .map((item) => Provider.fromJson(Map<String, dynamic>.from(item)))
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
        return RiwayatTransaksiResponseModel.fromJson(response.data);
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

  Future<StatusTransaksiModel> historyDetail(String kode) async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.post(
        "$baseURL/trx_by_kode/$kode",
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
      );
      if (response.statusCode == 200) {
        return StatusTransaksiModel.fromJson(response.data);
      }
      throw Exception(
        "Gagal mendapatkan detail history transaksi. Status: ${response.statusCode}",
      );
    } catch (e) {
      throw Exception(e.toString());
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
      log("DioException: $apiMessage");
      throw Exception(apiMessage);
    } catch (e) {
      log("Exception: $e");
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
      log("DioException: $apiMessage");
      throw Exception(apiMessage);
    } catch (e) {
      log("Exception: $e");
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
      log("DioException: $apiMessage");
      throw Exception(apiMessage);
    } catch (e) {
      log("Exception: $e");
      throw Exception(e.toString());
    }
  }

  Future<String> daftarMitra(
    String nama,
    String alamat,
    String nomor,
    int markup,
    String kodeReseller,
  ) async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.post(
        '$baseURL/user/register_downline',
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
        data: {
          "nama": nama,
          "alamat": alamat,
          "nomor": nomor,
          "markup": markup,
          "kode_reseller": kodeReseller,
        },
      );
      if (response.statusCode == 200) {
        return response.data["message"];
      } else {
        return "Gagal daftar: ${response.data["message"]}";
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? (e.response?.data ?? "Terjadi kesalahan server")
          : e.message;
      log("DioException: $apiMessage");
      throw Exception(apiMessage);
    } catch (e) {
      throw "Gagal menghubungi server";
    }
  }

  Future<MitraModel> fetchMitra(String kodeReseller) async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.post(
        '$baseURL/user/list_downline',
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
        data: {"kode_reseller": kodeReseller},
      );
      if (response.statusCode == 200) {
        return MitraModel.fromJson(response.data);
      } else {
        throw Exception("Gagal memuat mitra. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw "Gagal menghubungi server: $e";
    }
  }

  Future<MitraStatsModel> fetchMitraStats(String kodeReseller) async {
    try {
      final deviceID = await loadDeviceId();
      final response = await authService.dio.post(
        '$baseURL/user/downline_stats',
        options: Options(headers: {"x-device-id": "android-$deviceID"}),
        data: {"kode": kodeReseller},
      );
      if (response.statusCode == 200) {
        return MitraStatsModel.fromJson(response.data);
      } else {
        throw Exception(
          "Gagal memuat mitra stats. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw "Gagal menghubungi server: $e";
    }
  }
}
