import 'package:flutter/material.dart';
import 'package:xmlapp/core/helper/constant_finals.dart';
import '../../../core/helper/screen_handler.dart';
import '../../../core/utils/bottom_sheet.dart';

class KonfirmasiTukarPoin extends StatelessWidget {
  const KonfirmasiTukarPoin({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenHandler.init(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Konfirmasi Tukar Poin',
          style: TextStyle(
            color: kWhite,
            fontSize: ScreenHandler.f(18),
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: kOrange,
        actions: [
          IconButton(
            onPressed: () => showCSBottomSheet(context, "Hubungi CS"),
            icon: const Icon(Icons.headset_mic_rounded, color: kWhite),
          ),
        ],
      ),
      backgroundColor: kNeutral20,
      body: Column(
        children: [
          // === MAIN CARD ===
          Container(
            margin: const EdgeInsets.fromLTRB(16, 25, 16, 16),
            height: screenHeight * 0.60,
            decoration: BoxDecoration(
              color: kWhite,
              boxShadow: [
                BoxShadow(
                  color: kNeutral80,
                  blurRadius: 20,
                  spreadRadius: -25,
                  offset: const Offset(0, 30),
                ),
              ],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                CustomPaint(
                  painter: DottedLinePainter(),
                  size: Size(double.infinity, screenHeight * 0.12),
                ),
                CustomPaint(
                  painter: DottedLinePainter(),
                  size: Size(double.infinity, screenHeight * 0.56),
                ),
                CustomPaint(
                  painter: SideCutDesign(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    child: _buildContent(context),
                  ),
                ),
              ],
            ),
          ),

          // === ACTION BUTTONS ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildButton(label: 'Batal', color: kBlack, onPressed: () {}),
                const SizedBox(width: 12),
                _buildButton(
                  label: 'Konfirmasi',
                  color: kOrange,
                  onPressed: () {
                    // TODO: Konfirmasi aksi
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// === BODY CONTENT ===
  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textTitle('Detail Tukar Poin'),
        _textSub('Mohon konfirmasi permintaan tukar poin berikut ini'),
        const SizedBox(height: 30),

        // === INFORMASI AGEN ===
        _infoText('Nama Agen', 'SEO XML Tronik'),
        _infoText('ID Agen', 'XML112233'),

        _textLabel('Hadiah Tukar Poin'),
        const SizedBox(height: 8),
        Row(
          children: [
            Image.asset('assets/images/promo.jpg', width: 88, height: 88),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _textBody('Voucher XL Combo Flex'),
                _textSub('Qty: 1 Ton'),
              ],
            ),
          ],
        ),
        const Spacer(),
        _buildSummary(),
      ],
    );
  }

  /// === SECTION RINGKASAN ===
  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _textBody('Total Poin Ditukar'),
            Text(
              '120.000',
              style: TextStyle(
                fontSize: ScreenHandler.f(24),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: kYellow),
            const SizedBox(width: 8),
            Expanded(
              child: _textSub(
                'Mohon konfirmasikan detail penukaran poinmu kepada CS',
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// === HELPER WIDGETS ===
  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              color: kWhite,
              fontSize: ScreenHandler.f(14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _textTitle(String text) => Text(
    text,
    style: TextStyle(
      fontSize: ScreenHandler.f(18),
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _textSub(String text) => Text(
    text,
    style: TextStyle(
      fontSize: ScreenHandler.f(12),
      color: kNeutral70,
      fontWeight: FontWeight.w400,
    ),
  );

  Widget _textLabel(String text) => Text(
    text,
    style: TextStyle(
      fontSize: ScreenHandler.f(12),
      color: kNeutral70,
      fontWeight: FontWeight.w400,
    ),
  );

  Widget _textBody(String text) => Text(
    text,
    style: TextStyle(
      fontSize: ScreenHandler.f(14),
      fontWeight: FontWeight.w500,
    ),
  );

  Widget _infoText(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_textLabel(label), _textBody(value)],
    ),
  );
}

/// === CUSTOM PAINTERS ===
class SideCutDesign extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;
    final paint = Paint()
      ..color = kNeutral20
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
