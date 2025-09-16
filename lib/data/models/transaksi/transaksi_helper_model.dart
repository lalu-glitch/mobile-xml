class TransaksiModel {
  final String? tujuan;
  final String? kodeProduk;
  final String? namaProduk;
  final double? total;

  const TransaksiModel({
    this.tujuan,
    this.kodeProduk,
    this.namaProduk,
    this.total,
  });

  /// copyWith
  TransaksiModel copyWith({
    String? tujuan,
    String? kodeProduk,
    String? namaProduk,
    double? total,
  }) {
    return TransaksiModel(
      tujuan: tujuan ?? this.tujuan,
      kodeProduk: kodeProduk ?? this.kodeProduk,
      namaProduk: namaProduk ?? this.namaProduk,
      total: total ?? this.total,
    );
  }
}
