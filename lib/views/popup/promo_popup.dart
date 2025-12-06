import 'package:flutter/material.dart';

import '../../core/helper/constant_finals.dart';

class PromoPopup {
  static void show(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true, // tap luar untuk close
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: .circular(16)),
          insetPadding: const .all(24),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: .circular(16),
                child: _buildPromoImage(imagePath),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Container(
                    padding: .all(4),
                    decoration: BoxDecoration(
                      color: kBackground,
                      borderRadius: .circular(100),
                    ),
                    child: const Icon(Icons.close_rounded, color: kRed),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // helper fallback image
  static Widget _buildPromoImage(String imagePath) {
    // Jika path diawali "http", berarti itu URL network
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        // Builder untuk loading progress
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const SizedBox.shrink();
        },
        // Fallback jika gagal load network image
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Gagal load promo: $error');
          return Image.asset(
            'assets/images/fallback_promo.png',
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      // Kalau bukan URL (misalnya asset lokal)
      return Image.asset(imagePath, fit: BoxFit.cover);
    }
  }
}
