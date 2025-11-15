class TransaksiResponse {
  final bool success;
  final String kode;
  final String kodeProduk;
  final DateTime tglEntri;
  final DateTime tglStatus;
  final String tujuan;
  final double harga;
  final double saldoAwal;
  final double? komisi;
  final int statusTrx;
  final String? sn;
  final String? outbox;

  TransaksiResponse({
    required this.success,
    required this.kode,
    required this.kodeProduk,
    required this.tglEntri,
    required this.tglStatus,
    required this.tujuan,
    required this.harga,
    required this.saldoAwal,
    this.komisi,
    required this.statusTrx,
    this.sn,
    this.outbox,
  });

  factory TransaksiResponse.fromJson(Map<String, dynamic> json) {
    return TransaksiResponse(
      success: json['success'] ?? false,
      kode: json['kode'] ?? '',
      kodeProduk: json['kode_produk'] ?? '',
      tglEntri: DateTime.tryParse(json['tgl_entri'] ?? '') ?? DateTime.now(),
      tglStatus: DateTime.tryParse(json['tgl_status'] ?? '') ?? DateTime.now(),
      tujuan: json['tujuan'] ?? '',
      harga: (json['harga'] ?? 0).toDouble(),
      saldoAwal: (json['saldo_awal'] ?? 0).toDouble(),
      komisi: json['komisi'] != null
          ? (json['komisi'] as num).toDouble()
          : null,
      statusTrx: json['status_trx'] ?? 0,
      sn: json['sn'],
      outbox: json['outbox'],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'kode': kode,
    'kode_produk': kodeProduk,
    'tgl_entri': tglEntri.toIso8601String(),
    'tgl_status': tglStatus.toIso8601String(),
    'tujuan': tujuan,
    'harga': harga,
    'saldo_awal': saldoAwal,
    'komisi': komisi,
    'status_trx': statusTrx,
    'sn': sn,
    'outbox': outbox,
  };

  // Getter tambahan
  String get keterangan {
    switch (statusTrx) {
      case 0:
        return "Menunggu Jawaban";
      case 1:
        return "Sedang Proses";
      case 2:
        return "Transaksi Pending";
      case 4:
        return "Sedang Proses";
      case 20:
        return "Sukses";
      case 40:
        return "Gagal";
      case 43:
        return "Saldo Tidak Cukup";
      case 45:
        return "Stok Kosong";
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
      case 56:
        return "Nomor Blacklist";
      case 58:
        return "Nomor Tidak Aktif";

      default:
        return "Status Tidak Diketahui";
    }
  }

  bool get isSukses => statusTrx == 20;
}
