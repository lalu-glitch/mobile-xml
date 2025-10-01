import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class BankCard extends StatelessWidget {
  final String title;
  final String minimumTopUp;
  final VoidCallback klik;
  const BankCard({
    required this.title,
    required this.minimumTopUp,
    required this.klik,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: klik,
      child: Card(
        elevation: 0,
        shadowColor: kNeutral60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: kWhite,
        margin: const EdgeInsets.only(top: 6, bottom: 6),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/icons/bca.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              SizedBox(width: Screen.kSize16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    minimumTopUp,
                    style: TextStyle(fontSize: 13, color: kNeutral70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
