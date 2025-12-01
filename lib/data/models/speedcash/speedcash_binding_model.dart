class SpeedcashBindingModel {
  bool success;
  String service;
  int state;
  String redirectUrl;
  String message;

  SpeedcashBindingModel({
    required this.success,
    required this.service,
    required this.state,
    required this.redirectUrl,
    required this.message,
  });

  factory SpeedcashBindingModel.fromJson(Map<String, dynamic> json) =>
      SpeedcashBindingModel(
        success: json["success"] ?? false,
        service: json["service"],
        state: json["state"],
        redirectUrl: json["redirectUrl"],
        message: json["message"],
      );

  factory SpeedcashBindingModel.error(String message) {
    return SpeedcashBindingModel(
      success: false,
      service: "",
      state: 0,
      redirectUrl: "",
      message: message,
    );
  }
}
