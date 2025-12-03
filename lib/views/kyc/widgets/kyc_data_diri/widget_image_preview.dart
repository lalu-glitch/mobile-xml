import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';

class ImagePreviewItem extends StatelessWidget {
  final String label;
  final String? path;

  const ImagePreviewItem({super.key, required this.label, required this.path});

  @override
  Widget build(BuildContext context) {
    // Widget ini "mahal" karena memuat gambar/file.
    // Dengan menjadikannya class sendiri, Flutter hanya akan merender ulang
    // jika 'path' berubah, bukan saat keyboard naik turun.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: kNeutral50)),
        const SizedBox(height: 8),
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kNeutral30),
          ),
          child: path != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(File(path!), fit: BoxFit.scaleDown),
                )
              : const Center(
                  child: Icon(Icons.image_not_supported, color: kNeutral50),
                ),
        ),
      ],
    );
  }
}
