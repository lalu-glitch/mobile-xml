import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class MitraStatusCard extends StatelessWidget {
  final int activeCount;
  final int blockedCount;

  const MitraStatusCard({
    super.key,
    required this.activeCount,
    required this.blockedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 0,
      right: 0,
      child: Container(
        margin: .symmetric(horizontal: kSize16),
        child: Card(
          color: kWhite,
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: .circular(kSize16)),
          margin: .zero,
          child: Container(
            padding: .symmetric(vertical: kSize16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatusItem(
                    title: 'Jaringan Mitra Aktif',
                    count: activeCount,
                    backgroundColor: kGreen.withAlpha(64),
                    textColor: kGreen, // Text hijau gelap
                  ),
                ),

                Container(height: 84, width: 2, color: kNeutral50),

                Expanded(
                  child: _buildStatusItem(
                    title: 'Jaringan Mitra Terblokir',
                    count: blockedCount,
                    backgroundColor: kRed.withAlpha(64),
                    textColor: kRed, // Text merah gelap
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method untuk membangun setiap item status
  Widget _buildStatusItem({
    required String title,
    required int count,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: kBlack,
            fontWeight: .w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          margin: .symmetric(horizontal: 32),
          padding: const .symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: .circular(4),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: .w600,
                color: textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
