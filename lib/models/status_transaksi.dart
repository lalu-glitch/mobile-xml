class StatusTransaksi {
  final int kode;
  final String tujuan;
  final int statusTrx; // Ubah jadi int biar gampang mapping
  final String sn;
  final String outbox;

  StatusTransaksi({
    required this.kode,
    required this.tujuan,
    required this.statusTrx,
    required this.sn,
    required this.outbox,
  });

  factory StatusTransaksi.fromJson(Map<String, dynamic> json) {
    return StatusTransaksi(
      kode: json['kode'] ?? 0,
      tujuan: json['tujuan'] ?? '',
      statusTrx: int.tryParse(json['status_trx']?.toString() ?? '') ?? 0,
      sn: json['SN'] ?? '',
      outbox: json['outbox'] ?? '',
    );
  }

  /// Mapping kode status -> keterangan
  String get keterangan {
    switch (statusTrx) {
      case 1:
        return "Belum Diproses";
      case 2:
        return "Menunggu Jawaban";
      case 20:
        return "SUKSES";
      case 40:
        return "GAGAL";
      case 43:
        return "Saldo Tidak Cukup";
      case 47:
        return "Produk Gangguan";
      case 50:
        return "Dibatalkan";
      case 52:
        return "Tujuan Salah";
      case 53:
        return "Tujuan Di Luar Wilayah";
      case 55:
        return "Time Out";
      default:
        return "Status Tidak Diketahui";
    }
  }

  bool get isSukses => statusTrx == 20;
}
