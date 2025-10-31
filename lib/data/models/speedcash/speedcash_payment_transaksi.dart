class SpeedcashPaymentTransaksiModel {
  String requestId;
  bool success;
  String message;
  int state;
  String originalPartnerReferenceNo;
  String url;
  DateTime expiredAt;

  SpeedcashPaymentTransaksiModel({
    required this.requestId,
    required this.success,
    required this.message,
    required this.state,
    required this.originalPartnerReferenceNo,
    required this.url,
    required this.expiredAt,
  });

  factory SpeedcashPaymentTransaksiModel.fromJson(Map<String, dynamic> json) =>
      SpeedcashPaymentTransaksiModel(
        requestId: json["request_id"],
        success: json["success"],
        message: json["message"],
        state: json["state"],
        originalPartnerReferenceNo: json["originalPartnerReferenceNo"],
        url: json["url"],
        expiredAt: DateTime.parse(json["expiredAt"]),
      );

  Map<String, dynamic> toJson() => {
    "request_id": requestId,
    "success": success,
    "message": message,
    "state": state,
    "originalPartnerReferenceNo": originalPartnerReferenceNo,
    "url": url,
    "expiredAt": expiredAt.toIso8601String(),
  };
}
