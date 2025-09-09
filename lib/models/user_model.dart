class UserModel {
  final String nama;
  final String pemilik;
  final String nomor;
  final String alamat;
  final String provinsi;
  final String kabupaten;
  final String kecamatan;
  final String? referral; // Optional field
  final String? deviceId; // Optional field

  UserModel({
    required this.nama,
    required this.pemilik,
    required this.nomor,
    required this.alamat,
    required this.provinsi,
    required this.kabupaten,
    required this.kecamatan,
    this.referral, // Optional, can be null
    required this.deviceId, // Optional, can be null
  });

  // Factory constructor to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nama: json['nama'] as String,
      pemilik: json['pemilik'] as String,
      nomor: json['nomor'] as String,
      alamat: json['alamat'] as String,
      provinsi: json['provinsi'] as String,
      kabupaten: json['kabupaten'] as String,
      kecamatan: json['kecamatan'] as String,
      referral: json['referral'] as String?, // Nullable
      deviceId: json['deviceId'] as String?, // Nullable
    );
  }
}
