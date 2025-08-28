class ProviderData {
  final String namaProvider;
  final List<Produk> produk;

  ProviderData({required this.namaProvider, required this.produk});

  factory ProviderData.fromJson(Map<String, dynamic> json) {
    return ProviderData(
      namaProvider: json['nama_provider'] ?? '',
      produk: (json['produk'] as List<dynamic>)
          .map((item) => Produk.fromJson(item))
          .toList(),
    );
  }
}

class Produk {
  final String kode_produk;
  final String namaProduk;
  final int hargaJual;
  final int gangguan;

  Produk({
    required this.kode_produk,
    required this.namaProduk,
    required this.hargaJual,
    required this.gangguan,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      kode_produk: json['kode_produk'] ?? '',
      namaProduk: json['nama_produk'] ?? '',
      hargaJual: json['harga_jual'] ?? 0,
      gangguan: json['gangguan'] ?? 0,
    );
  }
}
