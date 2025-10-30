import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({required this.title, required this.imageUrl});

  final String? title;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: (imageUrl != null && imageUrl!.isNotEmpty)
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.contain,
                  placeholder: (_, __) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.business_rounded),
                )
              : const Icon(Icons.business_rounded, size: 30, color: kNeutral70),
        ),
        const SizedBox(width: 16),
        Text(
          title?.toUpperCase() ?? 'N/A',
          style: const TextStyle(
            color: kNeutral100,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
