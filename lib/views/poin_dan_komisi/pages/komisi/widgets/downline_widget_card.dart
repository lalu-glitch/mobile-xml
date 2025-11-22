import 'package:flutter/material.dart';

import '../../../../../core/helper/constant_finals.dart';

class DownlineCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhite,
      elevation: 2.0,
      margin: const .only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const .all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: .start,
          children: [
            buildTopSection(),
            const SizedBox(height: 12.0),
            const Divider(color: Colors.black12, height: 1),
            const SizedBox(height: 12.0),

            buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget buildTopSection() {
    return Row(
      mainAxisAlignment: .spaceBetween,
      crossAxisAlignment: .start,
      children: [
        const Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'SMS0795632',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: kBlack,
              ),
            ),
            SizedBox(height: 4.0),
            Text('Yeni', style: TextStyle(fontSize: 14, color: kGrey)),
          ],
        ),

        Container(
          padding: const .symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: kGreen.withAlpha(50),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Text(
            'Aktif',
            style: TextStyle(color: kGreen, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget buildBottomSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              buildDetailRow('Upline', 'SMS0795632'),
              const SizedBox(height: 8.0),
              buildDetailRow('Stok pulsa', '10.020.864'),
            ],
          ),
        ),
        const SizedBox(width: 16.0),

        Expanded(
          child: Column(
            children: [
              buildDetailRow('Trx sukses', '500'),
              const SizedBox(height: 8.0),
              buildDetailRow('Trx gagal', '3'),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: kGrey)),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: kBlack,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }
}
