class ProviderKartu {
  final String namaProvider;
  final List<Produk> produk;

  ProviderKartu({required this.namaProvider, required this.produk});

  factory ProviderKartu.fromJson(Map<String, dynamic> json) {
    return ProviderKartu(
      namaProvider: json['nama_provider'] ?? '',
      produk: (json['produk'] as List<dynamic>)
          .map((item) => Produk.fromJson(item))
          .toList(),
    );
  }
}

class Produk {
  final String kodeProduk;
  final String namaProduk;
  final int hargaJual;
  final int gangguan;
  final int bebasNominal;
  final int endUser;
  Produk({
    required this.kodeProduk,
    required this.namaProduk,
    required this.hargaJual,
    required this.gangguan,
    required this.bebasNominal,
    required this.endUser,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      kodeProduk: json['kode_produk'] ?? '',
      namaProduk: json['nama_produk'] ?? '',
      hargaJual: json['harga_jual'] ?? 0,
      gangguan: json['gangguan'] ?? 0,
      bebasNominal: json['bebas_nominal'] ?? 0,
      endUser: json['enduser'] ?? 0,
    );
  }
}
