import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constant_finals.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final TextStyle? style;
  final Icon? prefixIcon;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? iconColor;
  final Color? labelColor;
  final Color? floatingLabelColor;
  final double borderRadius;
  final TextAlign align;
  final TextCapitalization capitalization;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? textFormater;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    required this.controller,
    this.style,
    this.labelText,
    this.prefixIcon,
    this.borderColor,
    this.focusedBorderColor,
    this.iconColor,
    this.labelColor,
    this.floatingLabelColor,
    this.borderRadius = 10,
    this.align = TextAlign.start,
    this.capitalization = TextCapitalization.none,
    this.keyboardType,
    this.validator,
    this.textFormater,
    this.contentPadding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      textAlign: align,
      textCapitalization: capitalization,
      style: style,
      inputFormatters: textFormater,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor ?? kNeutral80),
        floatingLabelStyle: TextStyle(color: floatingLabelColor ?? kOrange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? kOrangeAccent500),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? kOrangeAccent500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: focusedBorderColor ?? kOrange,
            width: 2,
          ),
        ),
      ),
    );
  }
}
