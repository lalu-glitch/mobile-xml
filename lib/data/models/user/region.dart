class RegionModel {
  String requestId;
  bool success;
  String message;
  List<Region> data;

  RegionModel({
    required this.requestId,
    required this.success,
    required this.message,
    required this.data,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
    requestId: json["request_id"],
    success: json["success"],
    message: json["message"],
    data: List<Region>.from(json["data"].map((x) => Region.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "request_id": requestId,
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Region {
  String kode;
  String nama;

  Region({required this.kode, required this.nama});

  factory Region.fromJson(Map<String, dynamic> json) =>
      Region(kode: json["kode"], nama: json["nama"]);

  Map<String, dynamic> toJson() => {"kode": kode, "nama": nama};
}
