import 'package:equatable/equatable.dart';

class Ewallet extends Equatable {
  final String icon;
  final String kodeDompet;
  final String namaEwallet;
  final int aktif;
  final int saldo;
  final int bind;

  const Ewallet({
    required this.icon,
    required this.kodeDompet,
    required this.namaEwallet,
    required this.aktif,
    required this.saldo,
    required this.bind,
  });

  factory Ewallet.fromJson(Map<String, dynamic> json) => Ewallet(
    icon: json["icon"],
    kodeDompet: json["kode_dompet"],
    namaEwallet: json["nama_ewallet"],
    aktif: json["aktif"],
    saldo: json["saldo"],
    bind: json["bind"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "kode_dompet": kodeDompet,
    "nama_ewallet": namaEwallet,
    "aktif": aktif,
    "saldo": saldo,
    "bind": bind,
  };

  @override
  List<Object?> get props => [
    icon,
    kodeDompet,
    namaEwallet,
    aktif,
    saldo,
    bind,
  ];
}
