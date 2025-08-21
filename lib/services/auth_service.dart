import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../config/app_config.dart';

class AuthService {
  static final String baseUrl = "${AppConfig.baseUrlAuth}";
  final Dio _dio = Dio();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // Basic Auth Credentials
  static const String _basicUser = "xmlapp";
  static const String _basicPass = "apkxml";
  static final String _basicAuthHeader =
      "Basic ${base64Encode(utf8.encode("$_basicUser:$_basicPass"))}";

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
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  /// Ambil Device ID unik
  Future<String> _loadDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id ?? "unknown-device"; // fallback
    } catch (_) {
      return "unknown-device";
    }
  }

  /// Ambil Access Token
  Future<String?> getAccessToken() async {
    final jsonString = await storage.read(key: "userData");
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> userData = jsonDecode(jsonString);
      final accessToken = userData["accessToken"] as String?;
      if (accessToken == null || accessToken.isEmpty) return null;

      return _isTokenExpired(accessToken) ? null : accessToken;
    } catch (_) {
      return null;
    }
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
      // tetap coba baca message dari server kalau ada
      final serverMsg = (e.response?.data is Map)
          ? e.response?.data["message"]
          : e.response?.data?.toString();
      return {
        "success": false,
        "message":
            serverMsg ??
            "Error dari server (${e.response?.statusCode ?? 'unknown'})",
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

      // kalau sukses dan token ada → simpan
      if (isSuccess && response.data["accessToken"] != null) {
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

      // kalau gagal tapi server kasih message, tetap kirim ke UI
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
        "message":
            serverMsg ??
            "Error dari server (${e.response?.statusCode ?? 'unknown'})",
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

      final response = await _dio.post(
        "$baseUrl/refresh-token",
        data: {"refreshToken": refreshToken},
      );

      if (response.statusCode == 200 && response.data["accessToken"] != null) {
        userData["accessToken"] = response.data["accessToken"];
        userData["refreshToken"] = response.data["refreshToken"];
        await storage.write(key: "userData", value: jsonEncode(userData));
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }
}
