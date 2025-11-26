import 'package:flutter/material.dart';

import 'constant_finals.dart';

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

/// Pembuat Garis Putus-putus [gemini]
class DashedLineDivider extends StatelessWidget {
  const DashedLineDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey[300]),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Pemotong bentuk Struk dengan pinggiran Setengah Lingkaran (Scalloped) [gemini]
class InvertedCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Konfigurasi Ukuran Lubang
    // radius: seberapa besar/dalam lengkungan potongannya
    const double radius = 10.0;

    // diameter: lebar satu lubang (jarak antar titik)
    const double diameter = radius * 2;

    // 1. Mulai dari kiri atas (0,0) -> lurus ke kiri bawah
    path.lineTo(0, size.height);

    // 2. Loop membuat lengkungan masuk ke dalam
    double x = 1;

    while (x < size.width) {
      // Kita menggambar kurva dari titik saat ini (x) ke titik berikutnya (x + diameter)
      path.quadraticBezierTo(
        x + radius, // Control Point X: Tepat di tengah lubang
        size.height -
            radius, // Control Point Y: NAIK ke atas (masuk ke dalam kotak)
        x + diameter, // End Point X: Ujung lubang
        size.height, // End Point Y: Kembali ke garis dasar
      );
      x += diameter;
    }

    // 3. Tarik garis ke kanan atas lalu tutup
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Pemotong bentuk Tiket (Zigzag tajam bawah)
class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);

    // Logic Zigzag
    double x = 0;
    double y = size.height - 20;
    double increment = 10;

    while (x < size.width) {
      x += increment;
      y = (y == size.height - 20) ? size.height : size.height - 20;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
