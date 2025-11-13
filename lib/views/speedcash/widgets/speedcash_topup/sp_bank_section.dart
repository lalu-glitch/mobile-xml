import 'package:flutter/material.dart';

import '../rupiah_text_field.dart';

class BankSection extends StatelessWidget {
  const BankSection({required this.controller, super.key});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return RupiahTextField(controller: controller, fontSize: 25);
  }
}
