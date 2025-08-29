class UserBalance {
  final String namauser; // maps from 'nama'
  final String kodeReseller; // maps from 'kode_reseller'
  final int saldo; // maps from 'saldo'
  final int poin; // maps from 'poin'
  final String kodeLevel; // maps from 'kode_level'
  final List<EWallet> ewallet; // maps from 'ewallet'

  UserBalance({
    required this.namauser,
    required this.kodeReseller,
    required this.saldo,
    required this.poin,
    required this.kodeLevel,
    required this.ewallet,
  });

  factory UserBalance.fromJson(Map<String, dynamic> json) {
    return UserBalance(
      namauser: json['nama'] ?? '',
      kodeReseller: json['kode_reseller'] ?? '',
      saldo: _parseInt(json['saldo']),
      poin: _parseInt(json['poin']),
      kodeLevel: json['kode_level'] ?? '',
      ewallet: (json['ewallet'] as List<dynamic>? ?? [])
          .map((e) => EWallet.fromJson(e))
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

class EWallet {
  final String nama; // maps from 'nama'
  final String kodeDompet; // maps from 'kode_dompet'
  final int saldoEwallet; // maps from 'saldo_ewallet'

  EWallet({
    required this.nama,
    required this.kodeDompet,
    required this.saldoEwallet,
  });

  factory EWallet.fromJson(Map<String, dynamic> json) {
    return EWallet(
      nama: json['nama'] ?? '',
      kodeDompet: json['kode_dompet'] ?? '',
      saldoEwallet: UserBalance._parseInt(json['saldo_ewallet']),
    );
  }
}
