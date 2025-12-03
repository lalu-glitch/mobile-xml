class KYCModel {
  final String? name;
  final String? nik;
  final DateTime? birthDate;
  final String? ktpPath;
  final String? selfiePath;

  const KYCModel({
    this.name,
    this.nik,
    this.birthDate,
    this.ktpPath,
    this.selfiePath,
  });

  KYCModel copyWith({
    String? name,
    String? nik,
    DateTime? birthDate,
    String? ktpPath,
    String? selfiePath,
  }) {
    return KYCModel(
      name: name ?? this.name,
      nik: nik ?? this.nik,
      birthDate: birthDate ?? this.birthDate,
      ktpPath: ktpPath ?? this.ktpPath,
      selfiePath: selfiePath ?? this.selfiePath,
    );
  }
}
