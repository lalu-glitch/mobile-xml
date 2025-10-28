class GuideTopUpModel {
  List<DataPanduan> data;

  GuideTopUpModel({required this.data});

  factory GuideTopUpModel.fromJson(Map<String, dynamic> json) =>
      GuideTopUpModel(
        data: List<DataPanduan>.from(
          json["data"].map((x) => DataPanduan.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataPanduan {
  String label;
  bool isExpand;
  List<String> data;

  DataPanduan({
    required this.label,
    required this.isExpand,
    required this.data,
  });

  factory DataPanduan.fromJson(Map<String, dynamic> json) => DataPanduan(
    label: json["label"],
    isExpand: json["isExpand"],
    data: List<String>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "isExpand": isExpand,
    "data": List<String>.from(data.map((x) => x)),
  };
}
