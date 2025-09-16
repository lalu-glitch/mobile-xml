import 'package:flutter/material.dart';
//

import '../../core/helper/constant_finals.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "This is Analytics Page",
          style: TextStyle(fontSize: Screen.kSize20),
        ),
      ),
    );
  }
}
