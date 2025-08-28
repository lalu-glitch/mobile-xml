import 'package:flutter/material.dart';
import '../models/provider.dart';
import '../services/api_service.dart';

class ProviderViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ProviderData> _providers = [];
  bool _isLoading = false;
  String? _error;

  List<ProviderData> get providers => _providers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<Map<String, dynamic>> fetchProviders(
    String category,
    String tujuan,
  ) async {
    print("DEBUG: fetchProviders($category, $tujuan) called");
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.fetchProviders(category, tujuan);

      if (result["success"] == true) {
        _providers = result["data"] ?? [];
        _error = null;
      } else {
        _providers = [];
        _error = result["message"];
      }

      return result;
    } catch (e, stack) {
      _error = e.toString();
      print("DEBUG: Error in fetchProviders() -> $_error");
      print("DEBUG: Stacktrace -> $stack");
      return {"success": false, "data": null, "message": _error};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> fetchProvidersPrefix(
    String category,
    String tujuan,
  ) async {
    print("DEBUG: fetchProviders($category, $tujuan) called");
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.fetchProvidersPrefix(category, tujuan);

      if (result["success"] == true) {
        _providers = result["data"] ?? [];
        _error = null;
      } else {
        _providers = [];
        _error = result["message"];
      }

      return result;
    } catch (e, stack) {
      _error = e.toString();
      print("DEBUG: Error in fetchProviders() -> $_error");
      print("DEBUG: Stacktrace -> $stack");
      return {"success": false, "data": null, "message": _error};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearProviders() {
    _providers = [];
    _error = null;
    notifyListeners();
  }
}
