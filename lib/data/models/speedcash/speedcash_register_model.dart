class SpeedcashRegisterModel {
  String requestId;
  bool success;
  String message;
  String kodeReseller;
  String nomor;
  String type;
  String redirectUrl;
  DateTime expiresAt;

  SpeedcashRegisterModel({
    required this.requestId,
    required this.success,
    required this.message,
    required this.kodeReseller,
    required this.nomor,
    required this.type,
    required this.redirectUrl,
    required this.expiresAt,
  });

  factory SpeedcashRegisterModel.fromJson(Map<String, dynamic> json) =>
      SpeedcashRegisterModel(
        requestId: json["request_id"],
        success: json["success"],
        message: json["message"],
        kodeReseller: json["kode_reseller"],
        nomor: json["nomor"],
        type: json["type"],
        redirectUrl: json["redirect_url"],
        expiresAt: DateTime.parse(json["expiresAt"]),
      );

  //factory khusus error buat ngembaliin message errornya ke UI
  factory SpeedcashRegisterModel.error(String message) {
    return SpeedcashRegisterModel(
      requestId: "",
      success: false,
      message: message,
      kodeReseller: "",
      nomor: "",
      type: "",
      redirectUrl: "",
      expiresAt: DateTime.now(),
    );
  }
}
