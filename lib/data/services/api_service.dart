import 'package:dio/dio.dart';
import '../../core/helper/constant_finals.dart';
import '../models/produk/provider_kartu.dart';
import '../models/transaksi/status_transaksi.dart';
import '../models/transaksi/transaksi_riwayat.dart';
import '../models/transaksi/transaksi_response.dart';
import '../models/user/info_akun.dart';
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
      print('response : ${response.data}');
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
  Future<List<ProviderKartu>> fetchProviders(
    String category,
    String tujuan,
  ) async {
    try {
      final response = await authService.dio.post(
        "$baseURL/oto/all_produk/$category",
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

      throw Exception(
        jsonData["message"] ??
            "Gagal memuat provider. Status: ${response.statusCode}",
      );
    } on DioException catch (e) {
      final apiMessage = e.response?.data is Map
          ? e.response?.data["message"] ?? "Terjadi kesalahan pada server."
          : e.message;
      throw Exception(apiMessage);
    }
  }

  Future<List<ProviderKartu>> fetchProvidersPrefix(
    String category,
    String tujuan,
  ) async {
    try {
      final response = await authService.dio.post(
        "$baseURL/oto/all_produk_prefix/$category",
        data: {"tujuan": tujuan},
      );

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
      final response = await authService.dio.post(
        "$baseURL/transaksi",
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
      final response = await authService.dio.post(
        "$baseURL/trx_by_inbox/$kodeInbox",
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

  Future<RiwayatTransaksiResponseModel?> fetchHistory({
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
        return RiwayatTransaksiResponseModel.fromJson(data);
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
      final response = await authService.dio.get("$baseURL/info_akun");
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
}
