import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';

class KTPOverlayPainter extends CustomPainter {
  final Rect frameRect;
  KTPOverlayPainter({required this.frameRect});

  @override
  void paint(Canvas canvas, Size size) {
    // Menggunakan frameRect yang dilempar dari parent
    final RRect frameRRect = RRect.fromRectAndRadius(
      frameRect,
      const Radius.circular(12),
    );

    final Paint bgPaint = Paint()..color = kBlack.withAlpha(150);
    final Path bgPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final Path cutoutPath = Path()..addRRect(frameRRect);

    canvas.drawPath(
      Path.combine(PathOperation.difference, bgPath, cutoutPath),
      bgPaint,
    );

    final Paint borderPaint = Paint()
      ..color = const Color(0xFFFE7F04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final double cornerLength = 24.0;
    final Path cornerPath = Path();
    // TL
    cornerPath.moveTo(frameRect.left, frameRect.top + cornerLength);
    cornerPath.lineTo(frameRect.left, frameRect.top);
    cornerPath.lineTo(frameRect.left + cornerLength, frameRect.top);
    // TR
    cornerPath.moveTo(frameRect.right - cornerLength, frameRect.top);
    cornerPath.lineTo(frameRect.right, frameRect.top);
    cornerPath.lineTo(frameRect.right, frameRect.top + cornerLength);
    // BR
    cornerPath.moveTo(frameRect.right, frameRect.bottom - cornerLength);
    cornerPath.lineTo(frameRect.right, frameRect.bottom);
    cornerPath.lineTo(frameRect.right - cornerLength, frameRect.bottom);
    // BL
    cornerPath.moveTo(frameRect.left + cornerLength, frameRect.bottom);
    cornerPath.lineTo(frameRect.left, frameRect.bottom);
    cornerPath.lineTo(frameRect.left, frameRect.bottom - cornerLength);
    canvas.drawPath(cornerPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant KTPOverlayPainter oldDelegate) {
    return oldDelegate.frameRect != frameRect;
  }
}
