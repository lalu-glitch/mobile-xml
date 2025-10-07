class IconResponse {
  final List<SectionItem> data;

  IconResponse({required this.data});

  factory IconResponse.fromJson(Map<String, dynamic> json) {
    return IconResponse(
      data: (json['data'] as List).map((e) => SectionItem.fromJson(e)).toList(),
    );
  }
}

class SectionItem {
  final String section;
  final List<HeadingItem> data;

  SectionItem({required this.section, required this.data});

  factory SectionItem.fromJson(Map<String, dynamic> json) {
    return SectionItem(
      section: json['section'],
      data: (json['data'] as List).map((e) => HeadingItem.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'section': section,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class HeadingItem {
  final String heading;
  final List<IconItem> list;

  HeadingItem({required this.heading, required this.list});

  factory HeadingItem.fromJson(Map<String, dynamic> json) {
    return HeadingItem(
      heading: json['heading'],
      list: (json['list'] as List).map((e) => IconItem.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'heading': heading,
    'list': list.map((e) => e.toJson()).toList(),
  };
}

class IconItem {
  final String? icon; // digunakan di Promo
  final String? title; // digunakan di Layanan
  final String? url; // digunakan di Layanan
  final String kodeCatatan;
  final int? flow; // digunakan di Layanan

  IconItem({
    this.icon,
    this.title,
    this.url,
    required this.kodeCatatan,
    this.flow,
  });

  factory IconItem.fromJson(Map<String, dynamic> json) {
    return IconItem(
      icon: json['icon'],
      title: json['title'],
      url: json['url'],
      kodeCatatan: json['kode_catatan'] ?? '',
      flow: json['flow'],
    );
  }

  Map<String, dynamic> toJson() => {
    'icon': icon,
    'title': title,
    'url': url,
    'kode_catatan': kodeCatatan,
    'flow': flow,
  };
}
