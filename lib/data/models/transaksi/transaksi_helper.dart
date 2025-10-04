class TransaksiHelperModel {
  final String? tujuan;
  final String? kodeProduk;
  final String? namaProduk;
  final String? filename; // <---- dipake ke parameter prefix & prefix
  final double? total;
  final int? bebasNominal;
  final String? kodeDompet;

  const TransaksiHelperModel({
    this.tujuan,
    this.kodeProduk,
    this.namaProduk,
    this.filename,
    this.total,
    this.bebasNominal,
    this.kodeDompet,
  });

  /// copyWith
  TransaksiHelperModel copyWith({
    String? tujuan,
    String? kodeProduk,
    String? namaProduk,
    String? filename,
    double? total,
    int? bebasNominal,
    String? kodeDompet,
  }) {
    return TransaksiHelperModel(
      tujuan: tujuan ?? this.tujuan,
      kodeProduk: kodeProduk ?? this.kodeProduk,
      namaProduk: namaProduk ?? this.namaProduk,
      filename: filename ?? this.filename,
      total: total ?? this.total,
      bebasNominal: bebasNominal ?? this.bebasNominal,
      kodeDompet: kodeDompet ?? this.kodeDompet,
    );
  }
}
