import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/helper/constant_finals.dart';
import '../helper/prefix_controller.dart';

class InputNomorPrefixWidget extends StatelessWidget {
  const InputNomorPrefixWidget({
    super.key,
    required TextEditingController nomorController,
    required this.controller,
  }) : _nomorController = nomorController;

  final TextEditingController _nomorController;
  final DetailPrefixController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const Text("Nomor Tujuan"),
          const SizedBox(height: 8),
          TextField(
            controller: _nomorController,
            onChanged: controller.onNomorChanged,
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: .circular(8),
                borderSide: BorderSide(color: kOrange),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: .circular(10.0),
                borderSide: const BorderSide(color: kOrange),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: .circular(10.0),
                borderSide: const BorderSide(color: kOrange),
              ),
              hintText: "0812 1111 2222",
              suffixIcon: IconButton(
                icon: const Icon(Icons.contact_page),
                onPressed: () => controller.pickContact(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
