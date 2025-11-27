class TransaksiHelperModel {
  final String? tujuan;
  final String? kodeProduk;
  final String? namaProduk;
  final String? kodeCatatan;
  final double? productPrice; // harga produk (dari katalog)
  final double? fee; // biaya layanan / fee
  final double? finalTotal; // total pembayaran (tagihan + fee + extras)
  final int? isBebasNominal;
  final double? bebasNominalValue;
  final int? isEndUser;
  final String? endUserValue;
  final String? kodeDompet;
  final double? nominalPembayaran;
  final String? kodeCek;
  final String? kodeBayar;

  const TransaksiHelperModel({
    this.tujuan,
    this.kodeProduk,
    this.namaProduk,
    this.kodeCatatan,
    this.productPrice,
    this.fee,
    this.finalTotal,
    this.isBebasNominal,
    this.bebasNominalValue,
    this.isEndUser,
    this.endUserValue,
    this.kodeDompet,
    this.nominalPembayaran,
    this.kodeCek,
    this.kodeBayar,
  });

  TransaksiHelperModel copyWith({
    String? tujuan,
    String? kodeProduk,
    String? namaProduk,
    String? kodeCatatan,
    double? productPrice,
    double? fee,
    double? finalTotal,
    int? isBebasNominal,
    double? bebasNominalValue,
    int? isendUser,
    String? endUserValue,
    String? kodeDompet,
    double? nominalPembayaran,
    String? kodeCek,
    String? kodeBayar,
  }) {
    return TransaksiHelperModel(
      tujuan: tujuan ?? this.tujuan,
      kodeProduk: kodeProduk ?? this.kodeProduk,
      namaProduk: namaProduk ?? this.namaProduk,
      kodeCatatan: kodeCatatan ?? this.kodeCatatan,
      productPrice: productPrice ?? this.productPrice,
      fee: fee ?? this.fee,
      finalTotal: finalTotal ?? this.finalTotal,
      isBebasNominal: isBebasNominal ?? this.isBebasNominal,
      bebasNominalValue: bebasNominalValue ?? this.bebasNominalValue,
      isEndUser: isendUser ?? this.isEndUser,
      endUserValue: endUserValue ?? this.endUserValue,
      kodeDompet: kodeDompet ?? this.kodeDompet,
      nominalPembayaran: nominalPembayaran ?? this.nominalPembayaran,
      kodeCek: kodeCek ?? this.kodeCek,
      kodeBayar: kodeBayar ?? this.kodeBayar,
    );
  }
}
