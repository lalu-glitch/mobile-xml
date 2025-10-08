import 'package:flutter/material.dart';

import '../../poin_dan_komisi/widgets/widget_point_komisi.dart';

class PoinKomisi extends StatelessWidget {
  const PoinKomisi({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 96,
      left: 30,
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/poinPage'),
            child: PillPoinKomisiWidget(title: 'Poin', nominal: '500.200'),
          ),

          SizedBox(width: 24),

          InkWell(
            onTap: () => Navigator.pushNamed(context, '/komisiPage'),
            child: PillPoinKomisiWidget(title: 'Komisi', nominal: '1.900.670'),
          ),
        ],
      ),
    );
  }
}
