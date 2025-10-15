import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/bottom_sheet.dart';
import '../../auth/widgets/custom_textfield.dart';

class KomisiPage extends StatelessWidget {
  const KomisiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final komisiCtrl = TextEditingController();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBackground,
        appBar: AppBar(
          backgroundColor: kOrange,
          title: Text('Tukar Komisi Agen', style: TextStyle(color: kWhite)),
          iconTheme: const IconThemeData(color: kWhite),
          actions: [
            IconButton(
              onPressed: () => showCSBottomSheet(context, "Hubungi CS"),
              icon: Icon(Icons.headset_mic_rounded, color: kWhite),
            ),
          ],
        ),
        body: Stack(
          children: [
            // Lapisan background
            Container(color: kOrange),

            // Lapisan atas (isi layar)
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: kSize50 * 3),

                  // Body bawah (abu)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: kBackground,
                      child: Column(
                        children: [
                          SizedBox(height: kSize50 * 3),

                          TabBar(
                            labelColor: kOrange,
                            unselectedLabelColor: kNeutral80,
                            indicatorColor: kOrange,
                            tabs: const [
                              Tab(text: "Tukar Komisi"),
                              Tab(text: "Transaksi Downline"),
                            ],
                          ),

                          Expanded(
                            child: TabBarView(
                              children: [
                                // TAB 1: Tukar Komisi
                                ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: 10,
                                  itemBuilder: (context, index) => Card(
                                    child: ListTile(
                                      tileColor: kWhite,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(16),
                                      ),
                                      leading: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          color: kOrange,
                                        ),
                                        padding: EdgeInsets.all(12),
                                        child: const Icon(
                                          Icons.currency_exchange_rounded,
                                          color: kWhite,
                                        ),
                                      ),
                                      title: Text(
                                        'Tukar Komisi ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Tanggal: 2025-10-11',
                                        style: TextStyle(
                                          color: kNeutral80,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      trailing: Text(
                                        '+Rp25.000',
                                        style: TextStyle(
                                          color: kGreen,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // TAB 2: Transaksi Downline
                                ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: 8,
                                  itemBuilder: (context, index) => Card(
                                    child: ListTile(
                                      tileColor: kWhite,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(16),
                                      ),
                                      leading: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          color: kOrange,
                                        ),
                                        padding: EdgeInsets.all(12),
                                        child: const Icon(
                                          Icons.people_alt,
                                          color: kWhite,
                                        ),
                                      ),
                                      title: Text(
                                        'SMS0011-222-333 ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Ferry Irwandi',
                                        style: TextStyle(
                                          color: kNeutral80,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      trailing: Text(
                                        '+Rp99.000.000',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
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
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 16, right: 16, top: 32),
                child: Card(
                  elevation: 8,
                  color: kWhite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
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
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
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
            ),
          ],
        ),
      ),
    );
  }
}
