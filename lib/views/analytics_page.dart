import 'package:flutter/material.dart';

import '../services/auth_guard.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text("This is Analytics Page", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
