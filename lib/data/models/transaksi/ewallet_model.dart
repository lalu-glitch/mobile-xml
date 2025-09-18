class PaymentMethod {
  String? nama;
  String? kodeDompet;
  int? saldoEwallet;

  PaymentMethod({this.nama, this.kodeDompet, this.saldoEwallet});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
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
