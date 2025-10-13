import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class SideCutDesign extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;
    final paint = Paint()
      ..color = kBackground
      ..style = PaintingStyle.fill;

    for (final x in [0.0, w]) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(x, h / 1.40), radius: 18),
        0,
        10,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DottedLinePainter({
    this.color = kOrange,
    this.strokeWidth = 2.0,
    this.dashWidth = 4.0,
    this.dashSpace = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final lineY = size.height / 1.30;
    for (double x = 10; x < size.width - 10; x += dashWidth + dashSpace) {
      canvas.drawLine(Offset(x, lineY), Offset(x + dashWidth, lineY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
