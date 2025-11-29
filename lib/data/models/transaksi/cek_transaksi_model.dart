class CekTransaksiModel {
  final Map<String, dynamic> data;

  CekTransaksiModel(this.data);

  factory CekTransaksiModel.fromJson(Map<String, dynamic> json) {
    return CekTransaksiModel(json);
  }
}
