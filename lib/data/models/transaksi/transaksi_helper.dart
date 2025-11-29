class TransaksiHelperModel {
  // Data Produk
  final String? kodeProduk;
  final String? namaProduk;
  final String? kodeCatatan;
  final double? productPrice;
  final double? fee;
  final double? finalTotal;

  // Logic Flags (Ganti jadi boolean biar simpel)
  final bool isBebasNominal;
  final bool isEndUser;

  // Input User
  final double? bebasNominalValue;
  final String? endUserValue; // Voucher/ID Game
  final String? tujuan; // Nomor HP
  final String? kodeDompet;
  final double? nominalPembayaran;

  // System
  final String? kodeCek;
  final String? kodeBayar;

  const TransaksiHelperModel({
    this.kodeProduk,
    this.namaProduk,
    this.kodeCatatan,
    this.productPrice,
    this.fee,
    this.finalTotal,
    this.isBebasNominal = false, // Default false
    this.isEndUser = false, // Default false
    this.bebasNominalValue,
    this.endUserValue,
    this.tujuan,
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
    bool? isBebasNominal,
    double? bebasNominalValue,
    bool? isEndUser,
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
      isEndUser: isEndUser ?? this.isEndUser,
      endUserValue: endUserValue ?? this.endUserValue,
      kodeDompet: kodeDompet ?? this.kodeDompet,
      nominalPembayaran: nominalPembayaran ?? this.nominalPembayaran,
      kodeCek: kodeCek ?? this.kodeCek,
      kodeBayar: kodeBayar ?? this.kodeBayar,
    );
  }
}
