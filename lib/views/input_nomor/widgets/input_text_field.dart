import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/helper/constant_finals.dart';

Widget buildNomorTextField({
  required TextEditingController controller,
  required VoidCallback onPickContact,
}) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.phone,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(
      hintText: "Input Nomor Tujuan",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kOrange),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: kOrange),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: kOrange),
      ),
      suffixIcon: IconButton(
        icon: const Icon(Icons.contact_page),
        onPressed: onPickContact,
      ),
    ),
  );
}

Widget InputBebasNominal({required TextEditingController controller}) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.phone,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(
      hintText: "Input nominal",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: kOrange),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: kOrange),
      ),
      suffixIcon: const Icon(Icons.attach_money_rounded),
    ),
  );
}
