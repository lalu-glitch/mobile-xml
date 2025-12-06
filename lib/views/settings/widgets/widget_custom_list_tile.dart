// file: lib/widgets/custom_list_tile.dart
import 'package:flutter/material.dart';
import 'package:xmlapp/core/helper/constant_finals.dart';

class CustomListTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? label;
  final VoidCallback onTap;

  const CustomListTile({
    required this.imagePath,
    required this.title,
    this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          // Menggunakan CircleAvatar untuk latar belakang icon yang lebih rapi
          leading: CircleAvatar(
            backgroundColor: kOrange.withAlpha(15),
            foregroundColor: kOrange,
            radius: 20,
            child: Image.asset(imagePath, width: 20, height: 20),
          ),
          title: Text(title, style: const TextStyle(fontWeight: .w500)),
          trailing: Row(
            mainAxisSize: .min,
            children: [
              if (label != null)
                Container(
                  padding: const .symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (label == 'Baru') ? kOrange : null,
                    gradient: (label == 'Baru')
                        ? null
                        : LinearGradient(
                            colors: [Color(0xFFf4b95a), Color(0xFFba770c)],
                          ),
                    borderRadius: .circular(8),
                  ),
                  child: Text(
                    label!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: .bold,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 16, color: kBlack),
            ],
          ),
          onTap: onTap,
          contentPadding: const .symmetric(horizontal: 16, vertical: 0),
        ),
        // Divider yang lebih tipis dan sedikit ke dalam
        const Padding(padding: .only(left: 72, right: 16)),
      ],
    );
  }
}
