import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class BankCard extends StatelessWidget {
  final String title;
  final String minimumTopUp;
  final VoidCallback onTap;
  const BankCard({
    required this.title,
    required this.minimumTopUp,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: kWhite,
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      minimumTopUp,
                      style: TextStyle(fontSize: 13, color: kNeutral70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            // Tombol Pilih
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kOrangeAccent500,
                foregroundColor: kWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onTap,
              child: const Text(
                'Pilih',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
