//TODO [sesuaikan]
class SpeedcashRegisterModel {
  final String requestId;
  final bool success;
  final String message;
  final String redirectUrl;
  final int state;
  final String service;
  final String? kodeReseller;
  final String? nomor;
  final String? type;

  SpeedcashRegisterModel({
    required this.requestId,
    required this.success,
    required this.message,
    required this.redirectUrl,
    required this.state,
    required this.service,
    this.kodeReseller,
    this.nomor,
    this.type,
  });

  factory SpeedcashRegisterModel.fromJson(Map<String, dynamic> json) {
    return SpeedcashRegisterModel(
      requestId: json["request_id"] ?? "",
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      state: (json["state"] is int)
          ? json["state"]
          : int.tryParse(json["state"]?.toString() ?? "0") ?? 0,
      service: json["service"] ?? "",
      redirectUrl: json["redirectUrl"] ?? "",
      kodeReseller: json["kode_reseller"],
      nomor: json["nomor"],
      type: json["type"],
    );
  }

  // Factory error helper
  factory SpeedcashRegisterModel.error(String message) {
    return SpeedcashRegisterModel(
      requestId: "",
      success: false,
      message: message,
      redirectUrl: "",
      state: 0,
      service: "",
    );
  }
}
