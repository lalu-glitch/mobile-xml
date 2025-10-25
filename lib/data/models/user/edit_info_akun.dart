class UserEditModel {
  final bool success;
  final String message;
  final String? requestId;

  UserEditModel({required this.success, required this.message, this.requestId});

  factory UserEditModel.fromJson(Map<String, dynamic> json) {
    return UserEditModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      requestId: json["request_id"],
    );
  }
  Map<String, dynamic> toJson() {
    return {'request_id': requestId, 'success': success, 'message': message};
  }
}

// class UserEditModelHelper {
//   final int? markUpReferral;
//   final String? kodeReferral;
//   final String? nama;

//   UserEditModelHelper({
//     this.markUpReferral,
//     this.kodeReferral,
//     this.nama,
//   });

//   UserEditModelHelper copyWith({
//     int? markUpReferral,
//     String? kodeReferral,
//     String? nama,
//   }) {
//     return UserEditModelHelper(
//       markUpReferral: markUpReferral ?? this.markUpReferral,
//       kodeReferral: kodeReferral ?? this.kodeReferral,
//       nama: nama ?? this.nama,
//     );
//   }
// }
