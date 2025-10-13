import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/screen_handler.dart';
import 'text_helper.dart';

class ConfirmationSummary extends StatelessWidget {
  const ConfirmationSummary();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextBody('Total Poin Ditukar'),
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
        const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: kYellow),
            SizedBox(width: 8),
            Expanded(
              child: TextSub(
                'Mohon konfirmasikan detail penukaran poinmu kepada CS',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
