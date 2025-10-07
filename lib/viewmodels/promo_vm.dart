import 'package:flutter/material.dart';

import '../data/models/layanan/layanan_model.dart';
import '../data/services/api_service.dart';

class PromoViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<IconItem> _promoList = [];
  bool _isLoading = false;
  String? _error;

  List<IconItem> get promoList => _promoList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPromo() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.fetchIcons();
      final promoSection = response.data.firstWhere(
        (e) => e.section.toLowerCase() == 'promo',
      );

      // Ambil list pertama ("Pasti Promo")
      _promoList = promoSection.data.first.list;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
