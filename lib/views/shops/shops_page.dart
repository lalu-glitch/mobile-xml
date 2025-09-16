import 'package:flutter/material.dart';

import '../../core/helper/constant_finals.dart';
//

class ShopsPage extends StatelessWidget {
  const ShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "This is Shops Page",
          style: TextStyle(fontSize: Screen.kSize20),
        ),
      ),
    );
  }
}
