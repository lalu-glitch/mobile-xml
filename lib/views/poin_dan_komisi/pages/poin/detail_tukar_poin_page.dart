import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/utils/bottom_sheet.dart';
import '../../widgets/action_button.dart';
import '../../widgets/custom_painter_helper.dart';
import '../../widgets/text_helper.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
              height: 600,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  //top
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextTitle('Detail Tukar Poin'),
                          const TextSub(
                            'Mohon konfirmasi permintaan tukar poin berikut ini',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: DottedDivider(
                              color: kOrange,
                              strokeWidth: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //mid
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const InfoText('Nama Agen', 'SEO XML Tronik'),
                          const InfoText('ID Agen', 'XML112233'),
                          const TextLabel('Hadiah Tukar Poin'),
                          SizedBox(height: kSize12),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/promo.jpg',
                                width: 88,
                                height: 88,
                                // Placeholder jika gambar tidak ada
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 88,
                                    height: 88,
                                    color: kNeutral80,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: kWhite,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextBody('Voucher XL Combo Flex'),
                                  TextSub('Qty: 1 Ton'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //cut out
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomPaint(
                              painter: CardDecorationPainter(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //bottom
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextBody('Total Poin Ditukar'),
                              Text(
                                '120.000',
                                style: TextStyle(
                                  fontSize: 24,
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ActionButtons(),
              ),
            ),
            SizedBox(height: kSize32),
          ],
        ),
      ),
    );
  }
}
