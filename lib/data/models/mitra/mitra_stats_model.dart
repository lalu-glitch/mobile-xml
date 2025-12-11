class MitraStatsModel {
  final String requestId;
  final bool success;
  final int downlineAktif;
  final int downlineSuspend;

  MitraStatsModel({
    required this.requestId,
    required this.success,
    required this.downlineAktif,
    required this.downlineSuspend,
  });

  factory MitraStatsModel.fromJson(Map<String, dynamic> json) =>
      MitraStatsModel(
        requestId: json["request_id"],
        success: json["success"],
        downlineAktif: json["downline_aktif"],
        downlineSuspend: json["downline_suspend"],
      );

  Map<String, dynamic> toJson() => {
    "request_id": requestId,
    "success": success,
    "downline_aktif": downlineAktif,
    "downline_suspend": downlineSuspend,
  };
}
