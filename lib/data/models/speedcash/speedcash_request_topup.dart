class RequestTopUpModel {
  String requestId;
  bool success;
  String message;
  int state;
  DateTime requestAt;
  String bank;
  int nominal;
  String atasNama;
  String rekening;
  String keterangan;
  DateTime expiredAt;
  String statusTiket;

  RequestTopUpModel({
    required this.requestId,
    required this.success,
    required this.message,
    required this.state,
    required this.requestAt,
    required this.bank,
    required this.nominal,
    required this.atasNama,
    required this.rekening,
    required this.keterangan,
    required this.expiredAt,
    required this.statusTiket,
  });

  factory RequestTopUpModel.fromJson(Map<String, dynamic> json) =>
      RequestTopUpModel(
        requestId: json["request_id"],
        success: json["success"],
        message: json["message"],
        state: json["state"],
        requestAt: DateTime.parse(json["requestAt"]),
        bank: json["bank"],
        nominal: json["nominal"],
        atasNama: json["atasNama"],
        rekening: json["rekening"],
        keterangan: json["keterangan"],
        expiredAt: DateTime.parse(json["expiredAt"]),
        statusTiket: json["status_tiket"],
      );

  Map<String, dynamic> toJson() => {
    "request_id": requestId,
    "success": success,
    "message": message,
    "state": state,
    "requestAt": requestAt.toIso8601String(),
    "bank": bank,
    "nominal": nominal,
    "atasNama": atasNama,
    "rekening": rekening,
    "keterangan": keterangan,
    "expiredAt": expiredAt.toIso8601String(),
    "status_tiket": statusTiket,
  };
}
