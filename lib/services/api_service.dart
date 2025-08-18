import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/user_balance.dart';
import '../models/icon_data.dart';

class ApiService {
  final String baseUrl = "${AppConfig.baseUrlApp}";

  Future<UserBalance> fetchUserBalance() async {
    final response = await http.get(Uri.parse('$baseUrl/user_dummy'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UserBalance.fromJson(jsonData);
    } else {
      throw Exception('Failed to load user balance');
    }
  }

  /// Ambil icon dengan kategori (pulsa, ewallet, token, dll)
  Future<Map<String, List<IconItem>>> fetchIcons() async {
    final response = await http.get(Uri.parse('$baseUrl/list-icon'));

    if (response.statusCode == 200) {
      print("DEBUG: Raw API response = ${response.body}");

      final jsonData = json.decode(response.body);

      if (jsonData is Map) {
        final Map<String, List<IconItem>> parsedData = {};

        jsonData.forEach((key, value) {
          if (value is List) {
            parsedData[key] = value
                .map((item) => IconItem.fromJson(item))
                .toList();
          }
        });

        return parsedData;
      } else {
        throw Exception("Invalid JSON format for icons");
      }
    } else {
      throw Exception('Failed to load icons. Status: ${response.statusCode}');
    }
  }
}
