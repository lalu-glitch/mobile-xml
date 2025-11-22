import 'package:flutter/material.dart';

import '../../../../../core/helper/constant_finals.dart';
import '../../../../../core/utils/bottom_sheet.dart';
import '../widgets/komisi_card_widget.dart';
import '../widgets/transaksi_downline_widget.dart';
import '../widgets/tukar_komisi_widget.dart';

class KomisiPage extends StatelessWidget {
  const KomisiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final komisiCtrl = TextEditingController();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: SafeArea(
          child: Stack(
            children: [
              // Lapisan background
              Container(color: kOrange),
              // Lapisan atas
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: kSize50 * 3),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: kBackground,
                        child: Column(
                          children: [
                            SizedBox(height: kSize50 * 3.5),
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
                                  TukarKomisiTabPage(),
                                  // TAB 2: Transaksi Downline
                                  TransaksiDownlineTabPage(),
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
              CardWidget(komisiCtrl: komisiCtrl),
            ],
          ),
        ),
      ),
    );
  }
}
