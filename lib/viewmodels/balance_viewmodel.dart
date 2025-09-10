import 'package:flutter/material.dart';
import '../data/models/user_balance.dart';
import '../data/services/api_service.dart';

class BalanceViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  UserBalance? _userBalance;
  bool _isLoading = false;
  String? _error;

  UserBalance? get userBalance => _userBalance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBalance() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userBalance = await _apiService.fetchUserBalance();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
