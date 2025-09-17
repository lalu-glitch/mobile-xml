import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final IconData icons;
  final VoidCallback onTap;
  const SettingCard({
    super.key,
    required this.title,
    required this.icons,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icons, color: kOrange),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: Screen.kSize18),
        onTap: onTap,
      ),
    );
  }
}
