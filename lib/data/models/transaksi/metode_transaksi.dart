class PaymentMethodModel {
  String? nama;
  String? kodeDompet;
  int? saldoEwallet;

  PaymentMethodModel({this.nama, this.kodeDompet, this.saldoEwallet});

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        nama: json["nama"],
        kodeDompet: json["kode_dompet"],
        saldoEwallet: json["saldo_ewallet"],
      );

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "kode_dompet": kodeDompet,
    "saldo_ewallet": saldoEwallet,
  };
}
