import 'package:flutter/material.dart';

import '../../../../../core/helper/constant_finals.dart';
import '../../../../../core/utils/bottom_sheet.dart';
import '../widgets/action_button.dart';
import '../widgets/poin_exchange_ticket.dart';

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
            //card atau tiket yang isinya detail
            PoinExchangeTicket(),

            //button batal sama konfirmasi
            SafeArea(
              child: Padding(
                padding: const .symmetric(horizontal: 16),
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
