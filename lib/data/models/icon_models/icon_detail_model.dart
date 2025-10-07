class IconDetail {
  String? icon; // Digunakan di section "Promo"
  String kodeCatatan;
  String? filename; // Digunakan di section "Layanan"
  String? url; // Digunakan di section "Layanan"
  int? flow;

  IconDetail({
    this.icon,
    required this.kodeCatatan,
    this.filename,
    this.url,
    this.flow,
  });

  factory IconDetail.fromJson(Map<String, dynamic> json) => IconDetail(
    icon: json["icon"],
    kodeCatatan: json["kode_catatan"],
    filename: json["filename"],
    url: json["url"],
    flow: json["flow"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "kode_catatan": kodeCatatan,
    "filename": filename,
    "url": url,
    "flow": flow,
  };
}
