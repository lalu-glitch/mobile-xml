class DataBank {
  List<Bank> bank;
  List<VirtualAccount> va;

  DataBank({required this.bank, required this.va});

  factory DataBank.fromJson(Map<String, dynamic> json) => DataBank(
    bank: List<Bank>.from(json["bank"].map((x) => Bank.fromJson(x))),
    va: List<VirtualAccount>.from(
      json["va"].map((x) => VirtualAccount.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "bank": List<dynamic>.from(bank.map((x) => x.toJson())),
    "va": List<dynamic>.from(va.map((x) => x.toJson())),
  };
}

class Bank {
  String code;
  String name;
  String minDeposit;
  dynamic image;

  Bank({
    required this.code,
    required this.name,
    required this.minDeposit,
    required this.image,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    code: json["code"],
    name: json["name"],
    minDeposit: json["min_deposit"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "min_deposit": minDeposit,
    "image": image,
  };
}

class VirtualAccount {
  String image;
  String bank;
  String vaUsername;
  String fee;
  String admin;
  String vaNumber;

  VirtualAccount({
    required this.image,
    required this.bank,
    required this.vaUsername,
    required this.fee,
    required this.admin,
    required this.vaNumber,
  });

  factory VirtualAccount.fromJson(Map<String, dynamic> json) => VirtualAccount(
    image: json["image"],
    bank: json["bank"],
    vaUsername: json["va_username"],
    fee: json["fee"],
    admin: json["admin"],
    vaNumber: json["va_number"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "bank": bank,
    "va_username": vaUsername,
    "fee": fee,
    "admin": admin,
    "va_number": vaNumber,
  };
}
