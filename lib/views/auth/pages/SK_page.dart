import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class SyaratDanKetentuan extends StatelessWidget {
  const SyaratDanKetentuan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text(
          'Syarat & Ketentuan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: kWhite,
        scrolledUnderElevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diperbarui pada 02 Juli 2023',
              style: TextStyle(color: kOrange, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kWhite,
                  border: Border.all(color: kLightGrey, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                        Text('wasemanyema'),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kLightGrey,
                      foregroundColor: kBlack,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Kembali",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kOrange,
                      foregroundColor: kWhite,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Setuju",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
