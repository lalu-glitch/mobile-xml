import 'package:equatable/equatable.dart';

import 'ewallet_model.dart';

class UserBalance extends Equatable {
  final bool isLogout;
  final String? namauser;
  final String? kodeReseller;
  final int? saldo;
  final int? poin;
  final String? kodeLevel;
  final List<Ewallet>? ewallet;

  const UserBalance({
    required this.isLogout,
    this.namauser,
    this.kodeReseller,
    this.saldo,
    this.poin,
    this.kodeLevel,
    this.ewallet,
  });

  factory UserBalance.fromJson(Map<String, dynamic> json) {
    return UserBalance(
      isLogout: json['logout'],
      namauser: json['nama'] ?? '',
      kodeReseller: json['kode_reseller'] ?? '',
      saldo: _parseInt(json['saldo']),
      poin: _parseInt(json['poin']),
      kodeLevel: json['kode_level'] ?? '',
      ewallet: (json['ewallet'] as List<dynamic>? ?? [])
          .map((e) => Ewallet.fromJson(e))
          .toList(),
    );
  }

  // Helper function to parse int safely
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  List<Object?> get props => [
    isLogout,
    namauser,
    kodeReseller,
    saldo,
    poin,
    kodeLevel,
    ewallet,
  ];
}
