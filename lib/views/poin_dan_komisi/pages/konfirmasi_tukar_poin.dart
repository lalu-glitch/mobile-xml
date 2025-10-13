import 'package:flutter/material.dart';
import 'package:xmlapp/core/helper/constant_finals.dart';
import '../../../core/helper/screen_handler.dart';
import '../../../core/utils/bottom_sheet.dart';
import '../widgets/action_buttor.dart';
import '../widgets/confirmation_card_content.dart';
import '../widgets/custom_painter_helper.dart';

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
      backgroundColor: kBackground,
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
                    child: const ConfirmationCardContent(),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ActionButtons(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
