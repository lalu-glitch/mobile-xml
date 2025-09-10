class IconItem {
  final String filename;
  final String url;

  IconItem({required this.filename, required this.url});

  factory IconItem.fromJson(Map<String, dynamic> json) {
    return IconItem(filename: json['filename'] ?? '', url: json['url'] ?? '');
  }

  static List<IconItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => IconItem.fromJson(e)).toList();
  }
}
