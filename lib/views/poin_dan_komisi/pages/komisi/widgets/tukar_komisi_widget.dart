import 'package:flutter/material.dart';

import '../../../../../core/helper/constant_finals.dart';

class TukarKomisiTabPage extends StatelessWidget {
  const TukarKomisiTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          tileColor: kWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          leading: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: kOrange,
            ),
            padding: EdgeInsets.all(12),
            child: const Icon(Icons.currency_exchange_rounded, color: kWhite),
          ),
          title: Text(
            'Tukar Komisi ',
            style: TextStyle(fontWeight: FontWeight.w600),
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
    );
  }
}
