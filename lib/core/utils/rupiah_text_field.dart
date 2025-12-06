import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../helper/constant_finals.dart';

class RupiahTextField extends StatefulWidget {
  const RupiahTextField({
    required this.controller,
    required this.fontSize,
    super.key,
  });
  final double fontSize;
  final TextEditingController controller;
  @override
  State<RupiahTextField> createState() => _RupiahTextFieldState();
}

class _RupiahTextFieldState extends State<RupiahTextField> {
  final _formatter = NumberFormat.currency(
    locale: 'id', // Indonesia
    symbol: '', // kosong dulu, karena "Rp" kita kasih manual
    decimalDigits: 0,
  );

  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      final text = widget.controller.text.replaceAll('.', '');
      if (text.isEmpty) return;

      final value = int.parse(text);
      final newText = _formatter.format(value);

      //biar cursor gak selalu ke akhir pas user edit nominal
      final oldSelection = widget.controller.selection.baseOffset;
      final diff = newText.length - widget.controller.text.length;

      if (newText != widget.controller.text) {
        widget.controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: oldSelection + diff),
        );
      }
    };
    widget.controller.addListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: TextStyle(fontSize: widget.fontSize, color: kNeutral100),
      cursorColor: kOrangeAccent300,

      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const .only(left: 12, right: 8),
          child: Text(
            "Rp.",
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: .bold,
              color: kOrange,
            ),
          ),
        ),

        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: kBackground,
        isDense: true,
        border: OutlineInputBorder(borderRadius: .circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: .circular(12),
          borderSide: const BorderSide(color: kOrangeAccent300, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: .circular(12),
          borderSide: const BorderSide(color: kOrangeAccent300, width: 2),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }
}
