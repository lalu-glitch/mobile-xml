class TransaksiResponse {
  final bool success;
  final String message;
  final int? kodeInbox;

  TransaksiResponse({
    required this.success,
    required this.message,
    this.kodeInbox,
  });

  factory TransaksiResponse.fromJson(Map<String, dynamic> json) {
    return TransaksiResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      kodeInbox: json["kode_inbox"],
    );
  }
}
