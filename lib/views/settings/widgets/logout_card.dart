import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class LogoutCard extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.redAccent),
        title: const Text(
          "Logout",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
