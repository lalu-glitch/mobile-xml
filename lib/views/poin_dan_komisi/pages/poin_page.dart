import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/screen_handler.dart';
import '../../../core/utils/bottom_sheet.dart';
import '../../auth/widgets/custom_textfield.dart';

class PoinPage extends StatelessWidget {
  const PoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final poinCtrl = TextEditingController();
    ScreenHandler.init(context);

    return Scaffold(
      backgroundColor: kNeutral20,
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
              height: ScreenHandler.h(200),
              width: double.infinity,
              color: kOrange,
            ),

            // ======= MAIN CONTENT =======
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenHandler.h(32)),

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
                          Text(
                            'SEO XMLTRONIK',
                            style: TextStyle(fontSize: ScreenHandler.f(16)),
                          ),
                          Text(
                            'Merchant ID : SMS12532',
                            style: TextStyle(
                              fontSize: ScreenHandler.f(12),
                              color: kNeutral80,
                            ),
                          ),
                          SizedBox(height: ScreenHandler.h(20)),
                          Text(
                            '123.456.789',
                            style: TextStyle(
                              fontSize: ScreenHandler.f(32),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: ScreenHandler.h(16)),
                          SizedBox(
                            height: ScreenHandler.h(45),
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
                                      Navigator.pushNamed(context, '');
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
                          SizedBox(height: ScreenHandler.h(16)),
                          Row(
                            children: [
                              const Icon(Icons.warning_rounded, color: kYellow),
                              SizedBox(width: ScreenHandler.w(8)),
                              Expanded(
                                child: Text(
                                  'Kamu dapat menukarkan poin yang sudah terkumpul dengan stok pulsa. Minimal penukaran adalah 5000 poin.',
                                  style: TextStyle(
                                    fontSize: ScreenHandler.f(10),
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

                  SizedBox(height: ScreenHandler.h(32)),

                  // ===== HADIAH SPESIAL =====
                  Text(
                    'Hadiah Spesial',
                    style: TextStyle(
                      fontSize: ScreenHandler.f(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenHandler.h(16)),

                  SizedBox(
                    height: ScreenHandler.h(260),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: ScreenHandler.w(170),
                          margin: const EdgeInsets.only(right: 16),
                          child: Card(
                            elevation: 4,
                            color: kWhite,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: ScreenHandler.h(130),
                                  color: kNeutral40,
                                  child: const Center(
                                    child: Icon(
                                      Icons.card_giftcard,
                                      size: 50,
                                      color: kNeutral80,
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
                                        '1 iPhone 16 Pro Max',
                                        style: TextStyle(
                                          fontSize: ScreenHandler.f(14),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: ScreenHandler.h(4)),
                                      Text(
                                        'Stok tersedia: 2',
                                        style: TextStyle(
                                          fontSize: ScreenHandler.f(12),
                                          color: kNeutral80,
                                        ),
                                      ),
                                      SizedBox(height: ScreenHandler.h(8)),
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
                                              fontSize: ScreenHandler.f(12),
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

                  SizedBox(height: ScreenHandler.h(32)),

                  // ===== HADIAH LAINNYA =====
                  Text(
                    'Hadiah Lainnya',
                    style: TextStyle(
                      fontSize: ScreenHandler.f(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ScreenHandler.h(16)),

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
                                width: ScreenHandler.w(80),
                                height: ScreenHandler.h(80),
                                color: kNeutral40,
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 40,
                                    color: kNeutral80,
                                  ),
                                ),
                              ),
                              SizedBox(width: ScreenHandler.w(12)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '5000 Poin',
                                      style: TextStyle(
                                        fontSize: ScreenHandler.f(14),
                                        fontWeight: FontWeight.w600,
                                        color: kOrange,
                                      ),
                                    ),
                                    SizedBox(height: ScreenHandler.h(4)),
                                    Text(
                                      '1 Unit Power Bank',
                                      style: TextStyle(
                                        fontSize: ScreenHandler.f(14),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: ScreenHandler.h(4)),
                                    Text(
                                      'Stok tersedia: 100',
                                      style: TextStyle(
                                        fontSize: ScreenHandler.f(12),
                                        color: kNeutral80,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: ScreenHandler.w(12)),
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
                                  style: TextStyle(
                                    color: kWhite,
                                    fontSize: ScreenHandler.f(12),
                                  ),
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
