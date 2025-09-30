import 'dart:convert';

import 'package:flutter/services.dart';

import 'topup_dummy_model.dart';

class TopupRepository {
  Future<TopupModelDummy> getTopup() async {
    final String response = await rootBundle.loadString(
      'assets/topup_dummy.json',
    );
    final Map<String, dynamic> jsonMap =
        json.decode(response) as Map<String, dynamic>;

    // pastikan ada key "data"
    final Map<String, dynamic> dataMap =
        jsonMap['data'] as Map<String, dynamic>;
    return TopupModelDummy.fromJson(dataMap);
  }
}
