import 'package:flutter/material.dart';

import '../../core/helper/constant_finals.dart';
//

class ShopsPage extends StatelessWidget {
  const ShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Center(
        child: Text(
          "Halaman shops",
          style: TextStyle(fontSize: Screen.kSize20),
        ),
      ),
    );
  }
}
