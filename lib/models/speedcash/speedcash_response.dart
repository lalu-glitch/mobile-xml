class SpeedcashResponse {
  final String responseCode;
  final String responseMessage;
  final String? redirectUrl;

  SpeedcashResponse({
    required this.responseCode,
    required this.responseMessage,
    this.redirectUrl,
  });

  factory SpeedcashResponse.fromJson(Map<String, dynamic> json) {
    // Cek apakah response sukses atau gagal
    if (json.containsKey('responseCode')) {
      // Response sukses
      return SpeedcashResponse(
        responseCode: json['responseCode'] ?? '',
        responseMessage: json['responseMessage'] ?? '',
        redirectUrl: json['redirectUrl'],
      );
    } else if (json.containsKey('message')) {
      // Response gagal
      final msg = json['message'] as Map<String, dynamic>;
      return SpeedcashResponse(
        responseCode: msg['responseCode'] ?? '',
        responseMessage: msg['responseMessage'] ?? '',
        redirectUrl: null,
      );
    } else {
      // Default fallback
      return SpeedcashResponse(
        responseCode: '',
        responseMessage: 'Unknown response',
        redirectUrl: null,
      );
    }
  }
}
