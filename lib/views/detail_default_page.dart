import 'package:flutter/material.dart';
import '../models/icon_data.dart';
import '../viewmodels/icon_viewmodel.dart';

import '../services/auth_guard.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final iconItem = ModalRoute.of(context)!.settings.arguments as IconItem;
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text(iconItem.filename),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text("This is Detail Page", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
