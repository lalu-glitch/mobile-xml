import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class LogoutCard extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutCard({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhite,
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.redAccent),
        title: const Text(
          "Keluar",
          style: TextStyle(color: Colors.redAccent, fontWeight: .bold),
        ),
        onTap: onTap,
      ),
    );
  }
}
