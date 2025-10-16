import 'package:flutter/material.dart';
import '../data/models/layanan/layanan_model.dart';
import '../data/services/api_service.dart';

class LayananViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Map<String, List<IconItem>> _layananByHeading = {};
  bool _isLoading = false;
  String? _error;

  Map<String, List<IconItem>> get layananByHeading => _layananByHeading;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchLayanan() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.fetchIcons();
      final layananSection = response.data.firstWhere(
        (e) => e.section.toLowerCase() == 'layanan',
      );

      _layananByHeading = {
        for (var heading in layananSection.data) heading.heading: heading.list,
      };

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
