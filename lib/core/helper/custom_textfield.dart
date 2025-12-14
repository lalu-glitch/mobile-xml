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
          borderRadius: .circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? kOrangeAccent500),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: .circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? kOrangeAccent500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: .circular(borderRadius),
          borderSide: BorderSide(
            color: focusedBorderColor ?? kOrange,
            width: 2,
          ),
        ),
      ),
    );
  }
}

///TODO [implement globally]
class FintechInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final String? helperText;

  const FintechInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onFieldSubmitted,
    this.validator,
    this.inputFormatters,
    this.maxLines = 1,
    this.helperText,
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
            fontWeight: FontWeight.w500,
            color: kBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 15, color: kBlack),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: kNeutral50, fontSize: 14),
            helperText: helperText,
            helperStyle: TextStyle(color: kNeutral60, fontSize: 12),
            prefixIcon: Icon(icon, color: kNeutral60, size: 22),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            filled: true,
            fillColor: kWhite,
            // Border State: Normal
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: kNeutral30),
            ),
            // Border State: Focused (Aktif)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kOrange, width: 1.5),
            ),
            // Border State: Error
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kRed),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kRed, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
