import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/utils/bottom_sheet.dart';
import '../../../auth/widgets/custom_textfield.dart';

class PoinPage extends StatelessWidget {
  const PoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final poinCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kOrange,
        title: const Text('Tukar Poin Agen', style: TextStyle(color: kWhite)),
        iconTheme: const IconThemeData(color: kWhite),
        actions: [
          IconButton(
            onPressed: () => showCSBottomSheet(context, "Hubungi CS"),
            icon: const Icon(Icons.headset_mic_rounded, color: kWhite),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: kSize100 * 2,
              width: double.infinity,
              color: kOrange,
            ),

            // ======= MAIN CONTENT =======
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: kSize32),

                  // ===== CARD INFO AKUN =====
                  Card(
                    elevation: 8,
                    color: kWhite,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SEO XMLTRONIK', style: TextStyle(fontSize: 16)),
                          Text(
                            'Merchant ID : SMS12532',
                            style: TextStyle(fontSize: 12, color: kNeutral80),
                          ),
                          SizedBox(height: kSize20),
                          Text(
                            '123.456.789',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: kSize16),
                          SizedBox(
                            height: kSize44,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: CustomTextField(
                                    controller: poinCtrl,
                                    borderColor: kOrange,
                                    borderRadius: 14,
                                    contentPadding: const EdgeInsets.symmetric(
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
                                        '/detailTukarPoinPage',
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
                              const Icon(Icons.warning_rounded, color: kYellow),
                              SizedBox(width: kSize8),
                              Expanded(
                                child: Text(
                                  'Kamu dapat menukarkan poin yang sudah terkumpul dengan stok pulsa. Minimal penukaran adalah 5000 poin.',
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

                  SizedBox(height: kSize32),

                  // ===== HADIAH SPESIAL =====
                  Text(
                    'Hadiah Spesial',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: kSize16),

                  SizedBox(
                    height: kSize100 * 3,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: kSize80 * 2,
                          margin: const EdgeInsets.only(right: 16),
                          child: Card(
                            elevation: 0,
                            color: kWhite,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: kSize44 * 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: Image.asset(
                                      'assets/images/iphone_17_pm.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '23.000.000',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: kBlack,
                                        ),
                                      ),
                                      SizedBox(height: kSize18),
                                      Text(
                                        'iPhone 17 Pro Max',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Stok tersedia: 2',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: kNeutral80,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: kSize8),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kOrange,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            'Tukar Poin',
                                            style: TextStyle(
                                              color: kWhite,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: kSize32),

                  // ===== HADIAH LAINNYA =====
                  Text(
                    'Hadiah Lainnya',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: kSize16),

                  // List hadiah lainnya
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10, // contoh data dummy
                    itemBuilder: (context, index) {
                      return Card(
                        color: kWhite,
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
                                width: kSize80,
                                height: kSize80,
                                color: kNeutral40,
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: kNeutral80,
                                  ),
                                ),
                              ),
                              SizedBox(width: kSize12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '5000 Poin',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: kOrange,
                                      ),
                                    ),
                                    SizedBox(height: kSize4),
                                    Text(
                                      '1 Unit Power Bank',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: kSize4),
                                    Text(
                                      'Stok tersedia: 100',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: kNeutral80,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: kSize12),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Tukar',
                                  style: TextStyle(color: kWhite, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
