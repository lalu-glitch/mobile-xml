import 'package:dio/dio.dart';
import '../../core/constant_finals.dart';
import '../models/provider_kartu.dart';
import '../models/transaksi/status_transaksi.dart';
import '../models/transaksi/transaksi_riwayat.dart';
import '../models/transaksi/transaksi_response.dart';
import '../models/user/user_balance.dart';
import '../models/icon_models/icon_data.dart';
import 'auth_service.dart';
import 'package:logger/logger.dart';

class ApiService {
  final AuthService authService;
  final Logger logger;

  ApiService({AuthService? authService, Logger? logger})
    : authService = authService ?? AuthService(),
      logger = logger ?? Logger();

  /// Ambil saldo user
  Future<UserBalance> fetchUserBalance() async {
    try {
      final response = await authService.dio.get("$baseURL/get_user");

      if (response.statusCode == 200) {
        final dataMap = Map<String, dynamic>.from(response.data);
        return UserBalance.fromJson(dataMap);
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
      final response = await authService.dio.get("$baseURL/list-icon");

      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData is Map) {
          final Map<String, List<IconItem>> parsedData = {};
          jsonData.forEach((key, value) {
            if (value is List) {
              parsedData[key] = value
                  .map(
                    (item) =>
                        IconItem.fromJson(Map<String, dynamic>.from(item)),
                  )
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

  /// Ambil provider berdasarkan kategori dan tujuan
  Future<Map<String, dynamic>> fetchProviders(
    String category,
    String tujuan,
  ) async {
    try {
      final response = await authService.dio.post(
        "$baseURL/oto/all_produk/$category",
        data: {"tujuan": tujuan},
      );

      if (response.statusCode == 200) {
        final jsonData = Map<String, dynamic>.from(response.data);
        if (jsonData['data'] is List) {
          final providers = (jsonData['data'] as List)
              .map(
                (item) =>
                    ProviderKartu.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();

          return {
            "success": true,
            "data": providers,
            "message": jsonData["message"] ?? "Data provider berhasil dimuat.",
          };
        } else {
          return {
            "success": false,
            "data": null,
            "message": "Format data tidak sesuai.",
          };
        }
      } else {
        return {
          "success": false,
          "data": null,
          "message": "Gagal memuat provider. Status: ${response.statusCode}",
        };
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? e.response?.data["message"] ?? "Terjadi kesalahan pada server."
          : e.message;
      return {"success": false, "data": null, "message": apiMessage};
    }
  }

  Future<Map<String, dynamic>> fetchProvidersPrefix(
    String category,
    String tujuan,
  ) async {
    try {
      final response = await authService.dio.post(
        "$baseURL/oto/all_produk_prefix/$category",
        data: {"tujuan": tujuan},
      );
      print("daataa${response.statusCode}");
      if (response.statusCode == 200) {
        print("daataa ${response.data}");
        final jsonData = Map<String, dynamic>.from(response.data);
        if (jsonData['data'] is List) {
          final providers = (jsonData['data'] as List)
              .map(
                (item) =>
                    ProviderKartu.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();

          return {
            "success": true,
            "data": providers,
            "message": jsonData["message"] ?? "Data provider berhasil dimuat.",
          };
        } else {
          return {
            "success": false,
            "data": null,
            "message": "Format data tidak sesuai.",
          };
        }
      } else {
        return {
          "success": false,
          "data": null,
          "message": "Gagal memuat provider. Status: ${response.statusCode}",
        };
      }
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? e.response?.data["message"] ?? "Terjadi kesalahan pada server."
          : e.message;
      return {"success": false, "data": null, "message": apiMessage};
    }
  }

  /// Proses transaksi
  Future<Map<String, dynamic>> prosesTransaksi(
    String tujuan,
    String kode_produk,
    String kode_dompet,
  ) async {
    try {
      final response = await authService.dio.post(
        "$baseURL/transaksi",
        data: {
          "tujuan": tujuan,
          "kode_produk": kode_produk,
          "kode_dompet": kode_dompet,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = Map<String, dynamic>.from(response.data);
        return {
          "success": jsonData["success"] ?? false,
          "data": TransaksiResponse.fromJson(jsonData),
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
      final response = await authService.dio.post(
        "$baseURL/trx_by_inbox/$kodeInbox",
      );

      if (response.statusCode == 200) {
        final jsonData = Map<String, dynamic>.from(response.data);
        return {
          "success": true,
          "data": StatusTransaksi.fromJson(jsonData),
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

  Future<RiwayatTransaksiResponse?> fetchHistory({
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final response = await authService.dio.get(
        "$baseURL/history_transaksi",
        queryParameters: {"page": page, "limit": limit},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(
          response.data,
        );
        return RiwayatTransaksiResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data ?? e.message}");
      return null;
    } catch (e) {
      print("Other Error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> historyDetail(String kodeKode) async {
    try {
      final response = await authService.dio.post(
        "$baseURL/trx_by_kode/$kodeKode",
      );

      if (response.statusCode == 200) {
        final jsonData = Map<String, dynamic>.from(response.data);
        return {
          "success": true,
          "data": StatusTransaksi.fromJson(jsonData),
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
}
