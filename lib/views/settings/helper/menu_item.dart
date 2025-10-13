import 'package:flutter/material.dart';

class MenuItem {
  final String imagePath;
  final String title;
  final String? label;
  final VoidCallback onTap;

  MenuItem({
    required this.imagePath,
    required this.title,
    this.label,
    required this.onTap,
  });
}
