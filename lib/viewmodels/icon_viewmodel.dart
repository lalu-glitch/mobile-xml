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
    _isLoading = true;
    notifyListeners();

    try {
      final iconsData = await _apiService.fetchIcons();

      _iconsByCategory = iconsData;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
