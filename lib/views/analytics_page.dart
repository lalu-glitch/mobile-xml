import 'package:flutter/material.dart';


class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('Analytics', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orangeAccent[700],
      ),
      body: const Center(
        child: Text("This is Analytics Page", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
