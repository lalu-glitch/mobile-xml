import 'package:flutter/material.dart';

import '../services/auth_guard.dart';

class ShopsPage extends StatelessWidget {
  const ShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('Shops'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text("This is Shops Page", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
