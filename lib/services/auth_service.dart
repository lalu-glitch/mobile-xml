import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

class AuthService {
  static final String baseUrl = "${AppConfig.baseUrlAuth}";
  final Dio _dio = Dio();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers["x-access-token"] = token;
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final token = await getAccessToken();
              if (token != null && token.isNotEmpty) {
                e.requestOptions.headers["x-access-token"] = token;
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

  Future<String?> getAccessToken() async {
    final jsonString = await storage.read(key: "userData");
    if (jsonString == null) return null;
    try {
      final Map<String, dynamic> userData = jsonDecode(jsonString);
      return userData['accessToken'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final jsonString = await storage.read(key: "userData");
    if (jsonString == null) return false;
    try {
      final Map<String, dynamic> userData = jsonDecode(jsonString);
      final accessToken = userData['accessToken'] as String?;
      return accessToken != null && accessToken.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await _dio.post(
        "$baseUrl/auth/signup",
        data: {
          "username": username,
          "email": email,
          "password": password,
          "roles": ["user"], // role default
        },
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        "$baseUrl/auth/signin",
        data: {"username": username, "password": password},
      );

      if (response.statusCode == 200 && response.data["accessToken"] != null) {
        final jsonString = jsonEncode(response.data);
        await storage.write(key: "userData", value: jsonString);
        return {"success": true, "message": "Login berhasil"};
      }
      return {"success": false, "message": "Username atau password salah"};
    } on DioException catch (e) {
      String errorMessage = "Terjadi kesalahan server";
      if (e.response != null && e.response?.data != null) {
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        } else if (e.response?.data is String) {
          errorMessage = e.response?.data;
        }
      }
      return {"success": false, "message": errorMessage};
    } catch (_) {
      return {"success": false, "message": "Terjadi kesalahan tidak terduga"};
    }
  }

  Future<Map<String, dynamic>> sendOtp(String username, String nomor) async {
    try {
      final response = await _dio.post(
        "$baseUrl/send-otp",
        data: {"username": username, "nomor": nomor},
      );

      // ✅ Kalau sukses, balikin semua response.data
      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": response.data, // simpan full response dari server
          "message":
              response.data["message"] ??
              "Request Otp berhasil, cek Whatsapp untuk lihat kode OTP.",
        };
      }

      // kalau status != 200
      return {
        "success": false,
        "data": response.data,
        "message": response.data["message"] ?? "Terjadi kesalahan",
      };
    } on DioException catch (e) {
      // tangkap error dari server
      if (e.response != null && e.response?.data != null) {
        return {
          "success": false,
          "data": e.response?.data, // kirim semua isi error backend
          "message": e.response?.data['message'] ?? e.response?.data.toString(),
        };
      }
      return {
        "success": false,
        "message": e.message ?? "Terjadi kesalahan server",
      };
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String username, String otp) async {
    try {
      final response = await _dio.post(
        "$baseUrl/verify-otp",
        data: {"username": username, "otp": otp},
      );

      if (response.statusCode == 200 && response.data["accessToken"] != null) {
        // simpan ke secure storage
        final jsonString = jsonEncode(response.data);
        await storage.write(key: "userData", value: jsonString);

        return {"success": true, "message": "Verifikasi OTP berhasil"};
      }
      return {"success": false, "message": "Kode OTP salah"};
    } on DioException catch (e) {
      String errorMessage = "Terjadi kesalahan server";
      if (e.response != null && e.response?.data != null) {
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        } else if (e.response?.data is String) {
          errorMessage = e.response?.data;
        }
      }
      return {"success": false, "message": errorMessage};
    } catch (_) {
      return {"success": false, "message": "Terjadi kesalahan tidak terduga"};
    }
  }

  Future<void> logout() async {
    await storage.deleteAll();
  }

  Future<bool> _refreshToken() async {
    final jsonString = await storage.read(key: "userData");
    if (jsonString == null) return false;

    try {
      final Map<String, dynamic> userData = jsonDecode(jsonString);
      final refreshToken = userData['refreshToken'] as String?;
      if (refreshToken == null) return false;

      final response = await _dio.post(
        "$baseUrl/auth/refreshtoken",
        data: {"refreshToken": refreshToken},
      );

      if (response.statusCode == 200 && response.data["accessToken"] != null) {
        userData['accessToken'] = response.data["accessToken"];
        userData['refreshToken'] = response.data["refreshToken"];
        await storage.write(key: "userData", value: jsonEncode(userData));
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }
}
