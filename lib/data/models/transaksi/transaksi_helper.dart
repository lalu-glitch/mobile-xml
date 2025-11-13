class TransaksiHelperModel {
  final String? tujuan;
  final String? kodeProduk;
  final String? namaProduk;
  final String? kodeCatatan; // <---- dipake ke parameter prefix & prefix
  final double? total;
  final int? isBebasNominal;
  final int? bebasNominalValue;
  final int? isEndUser;
  final String? endUserValue;
  final String? kodeDompet;

  const TransaksiHelperModel({
    this.tujuan,
    this.kodeProduk,
    this.namaProduk,
    this.kodeCatatan,
    this.total,
    this.isBebasNominal,
    this.bebasNominalValue,
    this.isEndUser,
    this.endUserValue,
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
    int? isendUser,
    String? endUserValue,
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
      isEndUser: isendUser ?? isEndUser,
      endUserValue: endUserValue ?? this.endUserValue,
      kodeDompet: kodeDompet ?? this.kodeDompet,
    );
  }
}
