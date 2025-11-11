class UserBalance {
  final bool isLogout;
  final String? namauser;
  final String? kodeReseller;
  final int? saldo;
  final int? poin;
  final String? kodeLevel;
  final List<BalanceWallet>? ewallet;

  UserBalance({
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
          .map((e) => BalanceWallet.fromJson(e))
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
}

class BalanceWallet {
  final String nama; // maps from 'nama'
  final String kodeDompet; // maps from 'kode_dompet'
  final int saldoEwallet; // maps from 'saldo_ewallet'

  BalanceWallet({
    required this.nama,
    required this.kodeDompet,
    required this.saldoEwallet,
  });

  factory BalanceWallet.fromJson(Map<String, dynamic> json) {
    return BalanceWallet(
      nama: json['nama'] ?? '',
      kodeDompet: json['kode_dompet'] ?? '',
      saldoEwallet: UserBalance._parseInt(json['saldo_ewallet']),
    );
  }
}
