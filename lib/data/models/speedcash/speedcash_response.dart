class SpeedcashResponse {
  final bool success;
  final String service;
  final int state;
  final String? redirectUrl;

  SpeedcashResponse({
    required this.success,
    required this.service,
    required this.state,
    this.redirectUrl,
  });

  factory SpeedcashResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('success')) {
      return SpeedcashResponse(
        success: json['success'] ?? false,
        service: json['service'] ?? '',
        state: json['state'] ?? 0,
        redirectUrl: json['redirectUrl'],
      );
    } else if (json.containsKey('message')) {
      return SpeedcashResponse(
        success: false,
        service: json['message'] ?? 'Unknown error',
        state: 0,
        redirectUrl: null,
      );
    } else {
      return SpeedcashResponse(
        success: false,
        service: 'Unknown response',
        state: 0,
        redirectUrl: null,
      );
    }
  }

  /// Label untuk state
  String get stateLabel {
    switch (state) {
      case 1:
        return "Akun ditemukan dan aktif";
      case 2:
        return "Akun ditemukan & belum di binding";
      default:
        return "Tidak ada status";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "service": service,
      "state": state,
      "redirectUrl": redirectUrl,
    };
  }

  @override
  String toString() => toJson().toString(); // biar logger enak
}
