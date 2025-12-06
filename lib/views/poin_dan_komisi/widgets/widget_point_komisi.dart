import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class PillPoinKomisiWidget extends StatelessWidget {
  final String title;
  final String nominal; // <-- sementara pake string dulu
  const PillPoinKomisiWidget({
    required this.title,
    required this.nominal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: kWhite.withAlpha(100),
        borderRadius: .circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: .circular(100),
            ),
          ),
          SizedBox(width: 16),
          Column(
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: .w700,
                      color: kWhite,
                    ),
                  ),
                  Text(
                    nominal,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: .w500,
                      color: kWhite,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
