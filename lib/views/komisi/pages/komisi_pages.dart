import 'package:flutter/material.dart';

import '../../../core/constant_finals.dart';

class KomisiPage extends StatelessWidget {
  const KomisiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kOrange,
        title: Text(
          'Tukar Komisi',
          style: Styles.kNunitoBold.copyWith(color: kWhite),
        ),
        iconTheme: const IconThemeData(color: kWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Komisi',
              style: Styles.kNunitoBold.copyWith(
                color: kNeutral100,
                fontSize: Screen.kSize24,
              ),
            ),
            SizedBox(height: Screen.kSize12),
            Text(
              'Rp. 999.999.999.999',
              style: Styles.kNunitoMedium.copyWith(
                color: kNeutral100,
                fontSize: Screen.kSize48,
              ),
            ),
            SizedBox(height: Screen.kSize16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      kOrange, // Warna tombol merah yang lebih tegas
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Tukar komisi',
                  style: Styles.kNunitoSemiBold.copyWith(
                    color: kWhite,
                    fontSize: Screen.kSize16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
