class TopupModelDummy {
  int nominal;
  String tanggal;
  String keterangan;
  String namaBank;
  int rekening;
  String expired;

  TopupModelDummy({
    required this.nominal,
    required this.tanggal,
    required this.keterangan,
    required this.namaBank,
    required this.rekening,
    required this.expired,
  });

  factory TopupModelDummy.fromJson(Map<String, dynamic> json) =>
      TopupModelDummy(
        nominal: json["nominal"],
        tanggal: json["tanggal"],
        keterangan: json["keterangan"],
        namaBank: json["nama_bank"],
        rekening: json["rekening"],
        expired: json["expired"],
      );

  Map<String, dynamic> toJson() => {
    "nominal": nominal,
    "tanggal": tanggal,
    "keterangan": keterangan,
    "nama_bank": namaBank,
    "rekening": rekening,
    "expired": expired,
  };
}
