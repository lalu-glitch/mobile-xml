import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';

class KYCTimelineStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isFirst;
  final bool isLast;
  final Color kPrimary;

  const KYCTimelineStep({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.kPrimary,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Indicator
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: kWhite,
                  shape: .circle,
                  border: Border.all(color: kPrimary, width: 1.5),
                ),
                child: Icon(icon, size: 20, color: kPrimary),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: kNeutral40,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Text Content
          Expanded(
            child: Padding(
              padding: const .only(
                top: 8.0,
                bottom: 24.0,
              ), // Spacing between steps
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: kGrey,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
