import 'package:equatable/equatable.dart';

class RiwayatTransaksiResponseModel extends Equatable {
  final int total;
  final int totalPages;
  final int currentPage;
  final int perPage;
  final List<RiwayatTransaksi> items;

  RiwayatTransaksiResponseModel({
    required this.total,
    required this.totalPages,
    required this.currentPage,
    required this.perPage,
    required this.items,
  });

  factory RiwayatTransaksiResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawItems = json['data'] ?? [];
    return RiwayatTransaksiResponseModel(
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
      currentPage: json['current_page'] ?? 1,
      perPage: json['perPage'] ?? 5,
      items: rawItems
          .map((e) => RiwayatTransaksi.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [total, totalPages, currentPage, perPage, items];
}

class RiwayatTransaksi extends Equatable {
  final String kode;
  final String tujuan;
  final int status;
  final DateTime tglEntri;
  final double harga;

  RiwayatTransaksi({
    required this.kode,
    required this.tujuan,
    required this.status,
    required this.tglEntri,
    required this.harga,
  });

  factory RiwayatTransaksi.fromJson(Map<String, dynamic> json) {
    return RiwayatTransaksi(
      kode: json['kode']?.toString() ?? '',
      tujuan: json['tujuan']?.toString() ?? '',
      status: json['status'] ?? 0,
      tglEntri: DateTime.tryParse(json['tgl_entri'] ?? '') ?? DateTime.now(),
      harga: double.tryParse(json['harga']?.toString() ?? '0') ?? 0,
    );
  }

  String get keterangan {
    switch (status) {
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

  @override
  List<Object?> get props => [
    kode, //cukup kodenya aja
  ];
}
