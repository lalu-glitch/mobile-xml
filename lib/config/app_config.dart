import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Base URL utama
  // static const String baseUrlApp = "http://192.168.10.23:3009/api/v1";
  static String baseUrlApp = '${dotenv.env['BASE_URL']}';
}
