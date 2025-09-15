class IconItem {
  final String filename;
  final String url;
  final String kodeCatatan;
  final int flow;

  IconItem({
    required this.filename,
    required this.url,
    required this.kodeCatatan,
    required this.flow,
  });

  factory IconItem.fromJson(Map<String, dynamic> json) {
    return IconItem(
      filename: json['filename'],
      url: json['url'],
      kodeCatatan: json["kode_catatan"],
      flow: json["flow"],
    );
  }

  static List<IconItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => IconItem.fromJson(e)).toList();
  }
}
