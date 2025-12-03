import 'package:flutter/material.dart';

import 'widget_image_preview.dart';

class ConfirmImageSection extends StatelessWidget {
  final String? ktpPath;
  final String? selfiePath;

  const ConfirmImageSection({
    super.key,
    required this.ktpPath,
    required this.selfiePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Dokumen Pendukung",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ImagePreviewItem(label: "Foto KTP", path: ktpPath),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ImagePreviewItem(label: "Foto Selfie", path: selfiePath),
            ),
          ],
        ),
      ],
    );
  }
}
