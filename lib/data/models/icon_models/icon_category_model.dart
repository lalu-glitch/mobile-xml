import 'icon_detail_model.dart';

class IconCategory {
  String heading;
  List<IconDetail> list;

  IconCategory({required this.heading, required this.list});

  factory IconCategory.fromJson(Map<String, dynamic> json) => IconCategory(
    heading: json["heading"],
    list: List<IconDetail>.from(
      json["list"].map((x) => IconDetail.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "heading": heading,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}
