class Transaksi {
  final String id;
  final String tanggal;
  final String status;
  final String produk;
  final String nomor;
  final double total;

  Transaksi({
    required this.id,
    required this.tanggal,
    required this.status,
    required this.produk,
    required this.nomor,
    required this.total,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['kode']?.toString() ?? '',
      tanggal: json['tgl_entri']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      produk: "Top Up", // default karena API tidak ada field produk
      nomor: json['tujuan']?.toString() ?? '',
      total: double.tryParse(json['harga']?.toString() ?? "0") ?? 0,
    );
  }
}
