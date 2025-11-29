class TransaksiResponseModel {
  final bool success;
  final String message;
  final int? kodeInbox;

  TransaksiResponseModel({
    required this.success,
    required this.message,
    this.kodeInbox,
  });

  factory TransaksiResponseModel.fromJson(Map<String, dynamic> json) {
    return TransaksiResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      kodeInbox: json["kode_inbox"],
    );
  }
}
