import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class KYCStepItem extends StatelessWidget {
  const KYCStepItem({
    super.key,
    required this.icon,
    required this.text,
    required this.kSize44,
    required this.kSize12,
    required this.kSize14,
    required this.kSize8,
    required this.kOrange,
    required this.kNeutral30,
    required this.kBlack,
  });

  final IconData icon;
  final String text;
  final double kSize44;
  final double kSize12;
  final double kSize14;
  final double kSize8;
  final Color kOrange;
  final Color kNeutral30;
  final Color kBlack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kSize12),
      decoration: BoxDecoration(
        color: kNeutral30, // Light grey background like in design
        borderRadius: BorderRadius.circular(kSize14),
      ),
      child: Row(
        children: [
          Container(
            padding: .all(8),
            decoration: BoxDecoration(
              color: kOrange,
              borderRadius: BorderRadius.circular(kSize8),
            ),
            child: Icon(icon, color: kWhite, size: kSize24),
          ),
          SizedBox(width: kSize12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: kBlack,
                fontWeight: FontWeight.w600,
                fontSize: kSize14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
