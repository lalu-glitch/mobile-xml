import 'package:equatable/equatable.dart';

class InfoAkunModel extends Equatable {
  final String message;
  final Data data;

  const InfoAkunModel({required this.message, required this.data});

  factory InfoAkunModel.fromJson(Map<String, dynamic> json) => InfoAkunModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};

  @override
  List<Object?> get props => [message, data];
}

class Data extends Equatable {
  final String kodeReseller;
  final String? nama;
  final String? kodeLevel;
  final String kodeReferral;
  final int markupReferral;
  final int? saldo;
  final int? komisi;
  final int? poin;
  final int piutang;
  final int downline;
  final int trx;
  final int totalTrx;
  final int totalPemakaian;

  const Data({
    required this.kodeReseller,
    this.nama,
    this.kodeLevel,
    required this.kodeReferral,
    required this.markupReferral,
    this.saldo,
    this.komisi,
    this.poin,
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
    "komisi": komisi,
    "poin": poin,
    "piutang": piutang,
    "downline": downline,
    "trx": trx,
    "total_trx": totalTrx,
    "total_pemakaian": totalPemakaian,
  };

  @override
  List<Object?> get props => [
    kodeReseller,
    nama,
    kodeLevel,
    kodeReferral,
    markupReferral,
    saldo,
    komisi,
    poin,
    piutang,
    downline,
    trx,
    totalTrx,
    totalPemakaian,
  ];
}

// class Ewallet extends Equatable {
//   final int id;
//   final String icon;
//   final String nama;
//   final String kodeDompet;
//   final int binding;

//   const Ewallet({
//     required this.id,
//     required this.icon,
//     required this.nama,
//     required this.kodeDompet,
//     required this.binding,
//   });

//   factory Ewallet.fromJson(Map<String, dynamic> json) => Ewallet(
//     id: json["id"],
//     icon: json["icon"],
//     nama: json["nama"],
//     kodeDompet: json["kode_dompet"],
//     binding: json["binding"],
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "icon": icon,
//     "nama": nama,
//     "kode_dompet": kodeDompet,
//     "binding": binding,
//   };

//   @override
//   List<Object?> get props => [id, icon, nama, kodeDompet, binding];
// }
