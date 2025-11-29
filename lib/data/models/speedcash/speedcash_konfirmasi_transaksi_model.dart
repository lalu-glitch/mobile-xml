class SpeedcashKonfirmasiTransaksiModel {
  String requestId;
  bool success;
  String message;
  String originalPartnerReferenceNo;
  String tipeTransaksi;
  String kodeProduk;
  String namaProduk;
  int hargaJual;
  int fee;
  int total;
  DateTime expired;

  SpeedcashKonfirmasiTransaksiModel({
    required this.requestId,
    required this.success,
    required this.message,
    required this.originalPartnerReferenceNo,
    required this.tipeTransaksi,
    required this.kodeProduk,
    required this.namaProduk,
    required this.hargaJual,
    required this.fee,
    required this.total,
    required this.expired,
  });

  factory SpeedcashKonfirmasiTransaksiModel.fromJson(
    Map<String, dynamic> json,
  ) => SpeedcashKonfirmasiTransaksiModel(
    requestId: json["request_id"],
    success: json["success"],
    message: json["message"],
    originalPartnerReferenceNo: json["originalPartnerReferenceNo"],
    tipeTransaksi: json["tipe_transaksi"],
    kodeProduk: json["kode_produk"],
    namaProduk: json["nama_produk"],
    hargaJual: json["harga_jual"],
    fee: json["fee"],
    total: json["total"],
    expired: DateTime.parse(json["expired"]),
  );

  Map<String, dynamic> toJson() => {
    "request_id": requestId,
    "success": success,
    "message": message,
    "originalPartnerReferenceNo": originalPartnerReferenceNo,
    "tipe_transaksi": tipeTransaksi,
    "kode_produk": kodeProduk,
    "nama_produk": namaProduk,
    "harga_jual": hargaJual,
    "fee": fee,
    "total": total,
    "expired": expired.toIso8601String(),
  };
}
