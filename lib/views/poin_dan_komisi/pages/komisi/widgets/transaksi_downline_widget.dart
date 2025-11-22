import 'package:flutter/material.dart';

import '../../../../../core/helper/constant_finals.dart';
import 'downline_widget_card.dart';

class TransaksiDownlineTabPage extends StatelessWidget {
  const TransaksiDownlineTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: ListView.builder(
        padding: const .all(16.0),
        itemCount: 8,
        itemBuilder: (context, index) {
          return DownlineCard();
        },
      ),
    );
  }
}
