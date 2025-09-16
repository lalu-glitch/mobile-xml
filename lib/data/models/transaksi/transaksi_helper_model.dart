class TransaksiModel {
  final String? tujuan;
  final String? kodeProduk;
  final String? namaProduk;
  final String? filename; // <---- buat ke prefix
  final double? total;

  const TransaksiModel({
    this.tujuan,
    this.kodeProduk,
    this.namaProduk,
    this.filename,
    this.total,
  });

  /// copyWith
  TransaksiModel copyWith({
    String? tujuan,
    String? kodeProduk,
    String? namaProduk,
    String? filename,
    double? total,
  }) {
    return TransaksiModel(
      tujuan: tujuan ?? this.tujuan,
      kodeProduk: kodeProduk ?? this.kodeProduk,
      namaProduk: namaProduk ?? this.namaProduk,
      filename: filename ?? this.filename,
      total: total ?? this.total,
    );
  }
}
