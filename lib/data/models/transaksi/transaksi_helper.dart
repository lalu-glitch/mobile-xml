class TransaksiHelperModel {
  final String? tujuan;
  final String? kodeProduk;
  final String? namaProduk;
  final String? kodeCatatan; // <---- dipake ke parameter prefix & prefix
  final double? total;
  final int? isBebasNominal;
  final int? bebasNominalValue;
  final String? kodeDompet;

  const TransaksiHelperModel({
    this.tujuan,
    this.kodeProduk,
    this.namaProduk,
    this.kodeCatatan,
    this.total,
    this.isBebasNominal,
    this.bebasNominalValue,
    this.kodeDompet,
  });

  /// copyWith
  TransaksiHelperModel copyWith({
    String? tujuan,
    String? kodeProduk,
    String? namaProduk,
    String? kodeCatatan,
    double? total,
    int? isBebasNominal,
    final int? bebasNominalValue,
    String? kodeDompet,
  }) {
    return TransaksiHelperModel(
      tujuan: tujuan ?? this.tujuan,
      kodeProduk: kodeProduk ?? this.kodeProduk,
      namaProduk: namaProduk ?? this.namaProduk,
      kodeCatatan: kodeCatatan ?? this.kodeCatatan,
      total: total ?? this.total,
      isBebasNominal: isBebasNominal ?? this.isBebasNominal,
      bebasNominalValue: bebasNominalValue ?? this.bebasNominalValue,
      kodeDompet: kodeDompet ?? this.kodeDompet,
    );
  }
}
