import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/helper/constant_finals.dart';

class KYCTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatters;

  const KYCTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.inputType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kBlack,
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 16, color: kBlack),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: kNeutral50),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kNeutral50),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kOrange),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}
