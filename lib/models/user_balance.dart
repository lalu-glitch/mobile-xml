class UserBalance {
  final String namauser; // maps from 'nama'
  final String kodeReseller;
  final int saldo;
  final int poin;

  UserBalance({
    required this.namauser,
    required this.kodeReseller,
    required this.saldo,
    required this.poin,
  });

  factory UserBalance.fromJson(Map<String, dynamic> json) {
    return UserBalance(
      namauser: json['nama'] ?? '',
      kodeReseller: json['kode_reseller'] ?? '',
      saldo: _parseInt(json['saldo']),
      poin: _parseInt(json['poin']),
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
