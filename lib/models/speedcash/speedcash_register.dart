class SpeedcashRegisterResponse {
  final String responseCode;
  final String responseMessage;
  final String? redirectUrl;

  SpeedcashRegisterResponse({
    required this.responseCode,
    required this.responseMessage,
    this.redirectUrl,
  });

  factory SpeedcashRegisterResponse.fromJson(Map<String, dynamic> json) {
    // Cek apakah response sukses atau gagal
    if (json.containsKey('responseCode')) {
      // Response sukses
      return SpeedcashRegisterResponse(
        responseCode: json['responseCode'] ?? '',
        responseMessage: json['responseMessage'] ?? '',
        redirectUrl: json['redirectUrl'],
      );
    } else if (json.containsKey('message')) {
      // Response gagal
      final msg = json['message'] as Map<String, dynamic>;
      return SpeedcashRegisterResponse(
        responseCode: msg['responseCode'] ?? '',
        responseMessage: msg['responseMessage'] ?? '',
        redirectUrl: null,
      );
    } else {
      // Default fallback
      return SpeedcashRegisterResponse(
        responseCode: '',
        responseMessage: 'Unknown response',
        redirectUrl: null,
      );
    }
  }
}
