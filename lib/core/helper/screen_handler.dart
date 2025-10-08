import 'package:flutter/material.dart';

class ScreenHandler {
  static late double width;
  static late double height;
  static late double safeWidth;
  static late double safeHeight;
  static late double blockWidth;
  static late double blockHeight;
  static late TextScaler textScaler;

  static const double baseWidth = 375.0;
  static const double baseHeight = 812.0;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final padding = mediaQuery.padding;

    width = size.width;
    height = size.height;
    safeWidth = size.width - padding.left - padding.right;
    safeHeight = size.height - padding.top - padding.bottom;
    blockWidth = safeWidth / 100;
    blockHeight = safeHeight / 100;

    // ✅ versi baru, pengganti textScaleFactor
    textScaler = MediaQuery.textScalerOf(context);
  }

  static double w(double designWidth) {
    return designWidth * (safeWidth / baseWidth);
  }

  static double h(double designHeight) {
    return designHeight * (safeHeight / baseHeight);
  }

  static double f(double fontSize) {
    final scaled = fontSize * (safeWidth / baseWidth);
    return textScaler.scale(scaled);
  }
}
