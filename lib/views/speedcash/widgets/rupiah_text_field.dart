import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:xmlapp/core/helper/constant_finals.dart';

class RupiahTextField extends StatefulWidget {
  const RupiahTextField({super.key});

  @override
  State<RupiahTextField> createState() => _RupiahTextFieldState();
}

class _RupiahTextFieldState extends State<RupiahTextField> {
  final TextEditingController _controller = TextEditingController();
  final _formatter = NumberFormat.currency(
    locale: 'id', // Indonesia
    symbol: '', // kosong dulu, karena "Rp" kita kasih manual
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final text = _controller.text.replaceAll('.', '');
      if (text.isEmpty) return;

      final value = int.parse(text);
      final newText = _formatter.format(value);
      if (newText != _controller.text) {
        _controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(fontSize: 35, color: kNeutral100),
      cursorColor: kOrangeAccent300,
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12, right: 8),
          child: Text(
            "Rp.",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kOrange,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: kNeutral20,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kOrangeAccent300, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kOrangeAccent300, width: 2),
        ),
      ),
    );
  }
}
