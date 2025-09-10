class SpeedcashUnbindModel {
  bool success;
  String message;

  SpeedcashUnbindModel({required this.success, required this.message});

  factory SpeedcashUnbindModel.fromJson(Map<String, dynamic> json) =>
      SpeedcashUnbindModel(success: json["success"], message: json["message"]);

  Map<String, dynamic> toJson() => {"success": success, "message": message};
}
