class IconItem {
  String icon; // Digunakan di section "Promo"
  String kodeCatatan;
  String filename; // Digunakan di section "Layanan"
  String url; // Digunakan di section "Layanan"
  int flow;

  IconItem({
    required this.icon,
    required this.kodeCatatan,
    required this.filename,
    required this.url,
    required this.flow,
  });

  factory IconItem.fromJson(Map<String, dynamic> json) {
    return IconItem(
      icon: json["icon"],
      kodeCatatan: json["kode_catatan"],
      filename: json["filename"],
      url: json["url"],
      flow: json["flow"],
    );
  }

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "kode_catatan": kodeCatatan,
    "filename": filename,
    "url": url,
    "flow": flow,
  };
}
