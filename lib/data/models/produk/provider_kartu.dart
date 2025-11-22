class Provider {
  final String namaProvider;
  final List<Produk> produk;

  Provider({required this.namaProvider, required this.produk});

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
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
  final int postPaid;
  Produk({
    required this.kodeProduk,
    required this.namaProduk,
    required this.hargaJual,
    required this.gangguan,
    required this.bebasNominal,
    required this.endUser,
    required this.postPaid,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      kodeProduk: json['kode_produk'] ?? '',
      namaProduk: json['nama_produk'] ?? '',
      hargaJual: json['harga_jual'] ?? 0,
      gangguan: json['gangguan'] ?? 0,
      bebasNominal: json['bebas_nominal'] ?? 0,
      endUser: json['enduser'] ?? 0,
      postPaid: json['postpaid'] ?? 0,
    );
  }
}
