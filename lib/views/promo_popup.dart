import 'package:flutter/material.dart';

class PromoPopup {
  static void show(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true, // tap luar untuk close
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
              // Tombol close di pojok kanan atas
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
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
}
