import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class PoinKomisi extends StatelessWidget {
  const PoinKomisi({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 110,
      left: 25,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          SizedBox(width: 8),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Poin',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kWhite,
                    ),
                  ),
                  Text(
                    '500.200',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kWhite,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 30),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          SizedBox(width: 8),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Komisi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kWhite,
                    ),
                  ),
                  Text(
                    '1.800.200',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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
