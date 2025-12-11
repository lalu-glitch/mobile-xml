class MitraModel {
  final bool success;
  final List<Mitra> data;

  MitraModel({required this.success, required this.data});

  factory MitraModel.fromJson(Map<String, dynamic> json) => MitraModel(
    success: json["success"],
    data: List<Mitra>.from(json["data"].map((x) => Mitra.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Mitra {
  final String kode;
  final String nama;
  final int saldo;
  final int trxSukses;
  final int trxGagal;

  Mitra({
    required this.kode,
    required this.nama,
    required this.saldo,
    required this.trxSukses,
    required this.trxGagal,
  });

  factory Mitra.fromJson(Map<String, dynamic> json) => Mitra(
    kode: json["kode"],
    nama: json["nama"],
    saldo: json["saldo"],
    trxSukses: json["trx_sukses"],
    trxGagal: json["trx_gagal"],
  );

  Map<String, dynamic> toJson() => {
    "kode": kode,
    "nama": nama,
    "saldo": saldo,
    "trx_sukses": trxSukses,
    "trx_gagal": trxGagal,
  };

  //getter
  String get initials {
    if (nama.isEmpty) return '?';
    return nama[0].toUpperCase();
  }
}
