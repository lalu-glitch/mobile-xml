import 'package:flutter/material.dart';
import 'package:xmlapp/core/helper/constant_finals.dart';

import '../../../../core/utils/bottom_sheet.dart';
import '../../widgets/action_button.dart';
import '../../widgets/confirmation_card_content.dart';
import '../../widgets/custom_painter_helper.dart';

class DetailTukarPoin extends StatelessWidget {
  const DetailTukarPoin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Konfirmasi Tukar Poin',
          style: TextStyle(
            color: kWhite,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: kOrange,
        iconTheme: const IconThemeData(color: kWhite),
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
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 25, 16, 16),
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

              child: CustomPaint(
                painter: CardDecorationPainter(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: const ConfirmationCardContent(),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ActionButtons(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
