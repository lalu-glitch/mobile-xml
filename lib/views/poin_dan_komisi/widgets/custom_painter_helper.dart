import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class CardDecorationPainter extends CustomPainter {
  // Anda bisa membuat rasio ini bisa diubah jika perlu
  final double cutoutYRatio;
  final Color cutColor;
  final Color lineColor;
  final double lineDashWidth;
  final double lineDashSpace;

  CardDecorationPainter({
    this.cutoutYRatio = 1 / 1.4, // Menggunakan rasio dari SideCutDesign
    this.cutColor = kBackground,
    this.lineColor = kOrange,
    this.lineDashWidth = 4.0,
    this.lineDashSpace = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;
    // [PERBAIKAN]: Menetapkan satu posisi Y untuk keduanya
    final cutoutY = h * cutoutYRatio;

    // --- 1. Logika untuk Side Cut ---
    final cutPaint = Paint()
      ..color = cutColor
      ..style = PaintingStyle.fill;

    for (final x in [0.0, w]) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(x, cutoutY), radius: 18),
        0,
        10, // Angka besar untuk menggambar lingkaran penuh
        false,
        cutPaint,
      );
    }

    // --- 2. Logika untuk Dotted Line ---
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Memberi sedikit jarak dari tepi agar tidak menabrak potongan
    const padding = 25.0;
    for (
      double x = padding;
      x < w - padding;
      x += lineDashWidth + lineDashSpace
    ) {
      // [PERBAIKAN]: Menggunakan `cutoutY` yang sama untuk garis
      canvas.drawLine(
        Offset(x, cutoutY),
        Offset(x + lineDashWidth, cutoutY),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// [WIDGET BARU]
class DottedDivider extends StatelessWidget {
  const DottedDivider({
    super.key,
    this.height = 1,
    this.color = kNeutral80,
    this.dashWidth = 4.0,
    this.dashSpace = 4.0,
    this.strokeWidth = 3.0,
  });

  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _InlineDottedLinePainter(
          color: color,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          strokeWidth: strokeWidth,
        ),
        size: const Size(double.infinity, 1),
      ),
    );
  }
}

// Painter internal untuk DottedDivider
class _InlineDottedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  _InlineDottedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double startX = 0;
    final double endX = size.width;
    final double y = size.height / 2; // Menggambar di tengah tinggi widget

    for (double x = startX; x < endX; x += dashWidth + dashSpace) {
      final double endPoint = x + dashWidth;
      // Pastikan tidak menggambar melebihi batas
      final double dx = endPoint > endX ? endX : endPoint;
      canvas.drawLine(Offset(x, y), Offset(dx, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
