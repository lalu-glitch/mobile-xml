import 'package:flutter/material.dart';
import '../data/models/icon_models/icon_data.dart';
import '../data/services/api_service.dart';

class IconsViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Map<String, List<IconItem>> _iconsByCategory = {};
  bool _isLoading = false;
  String? _error;

  Map<String, List<IconItem>> get iconsByCategory => _iconsByCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchIcons() async {
    print("DEBUG: fetchIcons() called");
    _isLoading = true;
    notifyListeners();

    try {
      final iconsData = await _apiService.fetchIcons();
      print("DEBUG: Keys dari API = ${iconsData.keys}");

      _iconsByCategory = iconsData;
      _error = null;
    } catch (e, stack) {
      _error = e.toString();
      print("DEBUG: Error in fetchIcons() -> $_error");
      print("DEBUG: Stacktrace -> $stack");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
