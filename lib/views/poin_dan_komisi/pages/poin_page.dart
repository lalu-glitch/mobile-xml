import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/bottom_sheet.dart';

class PoinPage extends StatelessWidget {
  const PoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeutral20,
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
      body: Center(child: Text('Point Page')),
    );
  }
}
