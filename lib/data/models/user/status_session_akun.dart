class StatusSession {
  String requestId;
  bool success;
  String message;
  bool logout;

  StatusSession({
    required this.requestId,
    required this.success,
    required this.message,
    required this.logout,
  });

  factory StatusSession.fromJson(Map<String, dynamic> json) => StatusSession(
    requestId: json["request_id"],
    success: json["success"],
    message: json["message"],
    logout: json["logout"],
  );

  Map<String, dynamic> toJson() => {
    "request_id": requestId,
    "success": success,
    "message": message,
    "logout": logout,
  };
}
