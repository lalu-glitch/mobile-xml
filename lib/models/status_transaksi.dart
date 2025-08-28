class StatusTransaksi {
  final int kode;
  final String tujuan;
  final int statusTrx;
  final String sn;
  final String outbox;
  final String kodeProduk;
  final DateTime tglEntri;
  final DateTime lastUpdate;
  final String harga;
  final String komisi;

  StatusTransaksi({
    required this.kode,
    required this.tujuan,
    required this.statusTrx,
    required this.sn,
    required this.outbox,
    required this.kodeProduk,
    required this.tglEntri,
    required this.lastUpdate,
    required this.harga,
    required this.komisi,
  });

  factory StatusTransaksi.fromJson(Map<String, dynamic> json) {
    return StatusTransaksi(
      kode: json['kode'] is int
          ? json['kode']
          : int.tryParse(json['kode']?.toString() ?? '') ?? 0,
      tujuan: json['tujuan']?.toString() ?? '',
      statusTrx: int.tryParse(json['status_trx']?.toString() ?? '') ?? 0,
      sn: json['SN']?.toString() ?? '',
      outbox: json['outbox']?.toString() ?? '',
      kodeProduk: json['kode_produk']?.toString() ?? '',
      tglEntri:
          DateTime.tryParse(json['tgl_entri']?.toString() ?? '') ??
          DateTime.now(),
      lastUpdate:
          DateTime.tryParse(json['last_update']?.toString() ?? '') ??
          DateTime.now(),
      harga: json['harga']?.toString() ?? '0',
      komisi: json['komisi']?.toString() ?? '0',
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
