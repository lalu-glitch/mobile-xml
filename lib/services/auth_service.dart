import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../config/app_config.dart';
import 'package:android_id/android_id.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService extends ChangeNotifier {
  static final String baseUrl = AppConfig.baseUrlApp;
  final Dio _dio = Dio();
  final Dio _refreshDio = Dio(); // <-- DIO khusus refresh token

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // Basic Auth Credentials
  // static const String _basicUser = "xmlapp";
  // static const String _basicPass = "apkxml";
  // static final String _basicAuthHeader =
  //     "Basic ${base64Encode(utf8.encode("$_basicUser:$_basicPass"))}";

  final String _basicAuthHeader =
      "Basic " +
      base64Encode(
        utf8.encode("${dotenv.env['BASIC_USER']}:${dotenv.env['BASIC_PASS']}"),
      );
  AuthService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final token = await getAccessToken();
              if (token != null && token.isNotEmpty) {
                e.requestOptions.headers["Authorization"] = "Bearer $token";
                try {
                  final cloneReq = await _dio.fetch(e.requestOptions);
                  return handler.resolve(cloneReq);
                } catch (err) {
                  return handler.reject(err as DioException);
                }
              }
            } else {
              await logout();
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
  final logger = Logger();

  Future<String> _loadDeviceId() async {
    try {
      const androidIdPlugin = AndroidId();
      final androidId = await androidIdPlugin.getId();
      return androidId ?? "unknown-android-id";
    } catch (_) {
      return "unknown-device";
    }
  }

  /// Ambil Access Token
  Future<String?> getAccessToken() async {
    final jsonString = await storage.read(key: "userData");
    if (jsonString == null) return null;

    final userData = jsonDecode(jsonString) as Map<String, dynamic>;
    String? accessToken = userData["accessToken"];
    String? refreshToken = userData["refreshToken"];

    if (accessToken == null || refreshToken == null) return null;

    // Kalau accessToken expired → refresh dulu
    if (_isTokenExpired(accessToken)) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        final updated = await storage.read(key: "userData");
        if (updated != null) {
          final newData = jsonDecode(updated) as Map<String, dynamic>;
          return newData["accessToken"];
        }
      }
      await logout();
      return null;
    }

    return accessToken;
  }

  /// Cek apakah token expired
  bool _isTokenExpired(String token) {
    try {
      final parts = token.split(".");
      if (parts.length != 3) return true;

      final payload = _decodeBase64(parts[1]);
      final payloadMap = jsonDecode(payload) as Map<String, dynamic>;
      final exp = payloadMap["exp"];
      if (exp == null) return true;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(
        (exp as int) * 1000,
      );
      return DateTime.now().isAfter(expiryDate);
    } catch (_) {
      return true;
    }
  }

  String _decodeBase64(String str) {
    var output = str.replaceAll("-", "+").replaceAll("_", "/");
    switch (output.length % 4) {
      case 2:
        output += "==";
        break;
      case 3:
        output += "=";
        break;
    }
    return utf8.decode(base64Url.decode(output));
  }

  /// Cek login status
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }

  /// Kirim OTP dengan Basic Auth
  Future<Map<String, dynamic>> sendOtp(
    String kodeReseller,
    String nomor,
  ) async {
    try {
      final deviceId = await _loadDeviceId();
      final response = await _dio.post(
        "$baseUrl/send-otp",
        data: {
          "kode_reseller": kodeReseller,
          "nomor": nomor,
          "deviceID": deviceId,
        },
        options: Options(
          headers: {
            "Authorization": _basicAuthHeader,
            "Content-Type": "application/json",
          },
        ),
      );

      final isSuccess = response.statusCode == 200;
      return {
        "success": isSuccess,
        "data": response.data,
        "message":
            response.data["message"] ??
            (isSuccess
                ? "Request OTP berhasil, cek WhatsApp."
                : "Gagal kirim OTP (${response.data["message"]})"),
      };
    } on DioException catch (e) {
      final serverMsg = (e.response?.data is Map)
          ? e.response?.data["message"]
          : e.response?.data?.toString();
      return {
        "success": false,
        "message": serverMsg ?? "Error dari server (${e.response?.statusCode})",
      };
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  /// Verifikasi OTP
  Future<Map<String, dynamic>> verifyOtp(
    String kodeReseller,
    String otp,
  ) async {
    try {
      final response = await _dio.post(
        "$baseUrl/verify-otp",
        data: {"kode_reseller": kodeReseller, "otp": otp},
        options: Options(
          headers: {
            "Authorization": _basicAuthHeader,
            "Content-Type": "application/json",
          },
        ),
      );

      final isSuccess = response.statusCode == 200;

      if (isSuccess &&
          response.data["accessToken"] != null &&
          response.data["refreshToken"] != null) {
        final jsonString = jsonEncode({
          "accessToken": response.data["accessToken"],
          "refreshToken": response.data["refreshToken"],
        });
        await storage.write(key: "userData", value: jsonString);
        return {
          "success": true,
          "message": response.data["message"] ?? "Verifikasi OTP berhasil",
        };
      }

      return {
        "success": false,
        "message":
            response.data["message"] ??
            "Kode OTP salah (${response.statusCode})",
      };
    } on DioException catch (e) {
      final serverMsg = (e.response?.data is Map)
          ? e.response?.data["message"]
          : e.response?.data?.toString();
      return {
        "success": false,
        "message": serverMsg ?? "Error dari server (${e.response?.statusCode})",
      };
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> requestKodeAgen(String nomor) async {
    try {
      final response = await _dio.post(
        "$baseUrl/lupa_agen",
        data: {"nomor": nomor},
        options: Options(
          headers: {
            "Authorization": _basicAuthHeader,
            "Content-Type": "application/json",
          },
        ),
      );

      final isSuccess = response.statusCode == 200;
      return {
        "success": isSuccess,
        "data": response.data,
        "message":
            response.data["message"] ??
            (isSuccess
                ? "Permintaan kode agen berhasil, cek WhatsApp."
                : "Gagal kirim permintaan (${response.data["message"]})"),
      };
    } on DioException catch (e) {
      final serverMsg = (e.response?.data is Map)
          ? e.response?.data["message"]
          : e.response?.data?.toString();
      return {
        "success": false,
        "message": serverMsg ?? "Error dari server (${e.response?.statusCode})",
      };
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  Future<void> logout() async {
    await storage.deleteAll();
  }

  /// Refresh token
  Future<bool> _refreshToken() async {
    final jsonString = await storage.read(key: "userData");
    if (jsonString == null) return false;

    try {
      final userData = jsonDecode(jsonString) as Map<String, dynamic>;
      final refreshToken = userData["refreshToken"] as String?;
      if (refreshToken == null) return false;

      // Gunakan dio khusus refresh biar gak keintercept
      final response = await _refreshDio.post(
        "$baseUrl/refresh-token",
        data: {"refreshToken": refreshToken},
        options: Options(
          headers: {
            "Authorization": _basicAuthHeader,
            "Content-Type": "application/json",
          },
        ),
      );

      final newAccess = response.data["accessToken"];

      if (newAccess != null) {
        userData["accessToken"] = newAccess;
        // Hanya update refreshToken jika ada
        // if (newRefresh != null) userData["refreshToken"] = newRefresh;

        await storage.write(key: "userData", value: jsonEncode(userData));
        notifyListeners(); // biar UI refresh

        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
