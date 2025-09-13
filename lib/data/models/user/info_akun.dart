class InfoAkunModel {
  String kodeReseller;
  String nama;
  String kodeLevel;
  String kodeReferral;
  String markupReferral;
  int saldo;
  List<dynamic> ewallet;
  int komisi;
  int poin;
  int piutang;
  int downline;
  int trx;
  int totalTrx;
  int totalPemakaian;

  InfoAkunModel({
    required this.kodeReseller,
    required this.nama,
    required this.kodeLevel,
    required this.kodeReferral,
    required this.markupReferral,
    required this.saldo,
    required this.ewallet,
    required this.komisi,
    required this.poin,
    required this.piutang,
    required this.downline,
    required this.trx,
    required this.totalTrx,
    required this.totalPemakaian,
  });

  factory InfoAkunModel.fromJson(Map<String, dynamic> json) => InfoAkunModel(
    kodeReseller: json["kode_reseller"],
    nama: json["nama"],
    kodeLevel: json["kode_level"],
    kodeReferral: json["kode_referral"],
    markupReferral: json["markup_referral"],
    saldo: json["saldo"],
    ewallet: List<dynamic>.from(json["ewallet"].map((x) => x)),
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
    "ewallet": List<dynamic>.from(ewallet.map((x) => x)),
    "komisi": komisi,
    "poin": poin,
    "piutang": piutang,
    "downline": downline,
    "trx": trx,
    "total_trx": totalTrx,
    "total_pemakaian": totalPemakaian,
  };
}
