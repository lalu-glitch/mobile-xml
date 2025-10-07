import 'icon_category_model.dart';

class IconSection {
  String section;
  List<IconCategory> data;

  IconSection({required this.section, required this.data});

  factory IconSection.fromJson(Map<String, dynamic> json) => IconSection(
    section: json["section"],
    data: List<IconCategory>.from(
      json["data"].map((x) => IconCategory.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "section": section,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
