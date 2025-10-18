import 'package:flutter/material.dart';

import '../../../../../core/helper/constant_finals.dart';
import '../../../../auth/widgets/custom_textfield.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.komisiCtrl});

  final TextEditingController komisiCtrl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 32),
        child: Card(
          elevation: 8,
          color: kWhite,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // dinamis sesuai konten
              children: [
                Text('SEO XMLTRONIK', style: TextStyle(fontSize: 16)),
                Text(
                  'Merchant ID : SMS12532',
                  style: TextStyle(fontSize: 12, color: kNeutral80),
                ),
                SizedBox(height: kSize20),
                Text(
                  '123.456.789',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: kSize16),

                // input field
                SizedBox(
                  height: kSize44,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomTextField(
                          controller: komisiCtrl,
                          borderColor: kOrange,
                          borderRadius: 14,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detailTukarKomisiPage',
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: kOrange,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Text(
                              'Tukar',
                              style: TextStyle(
                                color: kWhite,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: kSize16),
                Row(
                  children: [
                    Icon(Icons.warning_rounded, color: kYellow),
                    SizedBox(width: kSize8),
                    Expanded(
                      child: Text(
                        'Setiap akhir bulan akan dilakukan pencairan Margin mitra massal pada jam 23.50 WIB',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: kNeutral80,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
