import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../poin_dan_komisi/widgets/widget_point_komisi.dart';

class PoinKomisi extends StatelessWidget {
  const PoinKomisi({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 105,
      left: 30,
      child: Row(
        children: [
          PillPoinKomisiWidget(title: 'Poin', nominal: '500.200'),

          SizedBox(width: 24),

          PillPoinKomisiWidget(title: 'Komisi', nominal: '1.900.670'),
        ],
      ),
    );
  }
}
