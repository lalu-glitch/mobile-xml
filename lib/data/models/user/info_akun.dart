class InfoAkunModel {
  String message;
  Data data;

  InfoAkunModel({required this.message, required this.data});

  factory InfoAkunModel.fromJson(Map<String, dynamic> json) => InfoAkunModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  String kodeReseller;
  String nama;
  String kodeLevel;
  String kodeReferral;
  String markupReferral;
  int saldo;
  List<Ewallet>? ewallet;
  int komisi;
  int poin;
  int piutang;
  int downline;
  int trx;
  int totalTrx;
  int totalPemakaian;

  Data({
    required this.kodeReseller,
    required this.nama,
    required this.kodeLevel,
    required this.kodeReferral,
    required this.markupReferral,
    required this.saldo,
    this.ewallet,
    required this.komisi,
    required this.poin,
    required this.piutang,
    required this.downline,
    required this.trx,
    required this.totalTrx,
    required this.totalPemakaian,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    kodeReseller: json["kode_reseller"],
    nama: json["nama"],
    kodeLevel: json["kode_level"],
    kodeReferral: json["kode_referral"],
    markupReferral: json["markup_referral"],
    saldo: json["saldo"],
    ewallet: json["ewallet"] != null
        ? List<Ewallet>.from(
            (json["ewallet"] as List).map((x) => Ewallet.fromJson(x)),
          )
        : [],
    komisi: json["komisi"],
    poin: json["poin"],
    piutang: json["piutang"],
    downline: json["downline"],
    trx: json["trx"],
    totalTrx: json["total_trx"],
    totalPemakaian: json["total_pemakaian"],
  );

  Map<String, dynamic> toJson() => {
    "kode_reseller": kodeReseller,
    "nama": nama,
    "kode_level": kodeLevel,
    "kode_referral": kodeReferral,
    "markup_referral": markupReferral,
    "saldo": saldo,
    "ewallet": ewallet?.map((x) => x.toJson()).toList(),
    "komisi": komisi,
    "poin": poin,
    "piutang": piutang,
    "downline": downline,
    "trx": trx,
    "total_trx": totalTrx,
    "total_pemakaian": totalPemakaian,
  };
}

class Ewallet {
  int id;
  String icon;
  String nama;
  String kodeDompet;
  int binding;

  Ewallet({
    required this.id,
    required this.icon,
    required this.nama,
    required this.kodeDompet,
    required this.binding,
  });

  factory Ewallet.fromJson(Map<String, dynamic> json) => Ewallet(
    id: json["id"],
    icon: json["icon"],
    nama: json["nama"],
    kodeDompet: json["kode_dompet"],
    binding: json["binding"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "icon": icon,
    "nama": nama,
    "kode_dompet": kodeDompet,
    "binding": binding,
  };
}
