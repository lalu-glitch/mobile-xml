import 'icon_section_model.dart';

/// Model utama yang memegang seluruh respons API
class IconListModel {
  String requestId;
  bool success;
  String message;
  List<IconSection> data;

  IconListModel({
    required this.requestId,
    required this.success,
    required this.message,
    required this.data,
  });

  factory IconListModel.fromJson(Map<String, dynamic> json) => IconListModel(
    requestId: json["request_id"],
    success: json["success"],
    message: json["message"],
    data: List<IconSection>.from(
      json["data"].map((x) => IconSection.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "request_id": requestId,
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
