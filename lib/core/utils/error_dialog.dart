import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../helper/constant_finals.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon error
              Container(
                decoration: BoxDecoration(
                  color: kRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(16),
                child: const Icon(Icons.error_outline, color: kRed, size: 48),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                "Error",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kRed,
                ),
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 24),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

enum ToastType { success, complete, warning, error }

void showAppToast(BuildContext context, String message, ToastType type) {
  final fToast = FToast();
  fToast.init(context);

  // Tentukan warna & ikon sesuai tipe
  late Color bgColor;
  late IconData icon;

  switch (type) {
    case ToastType.success:
      bgColor = kGreen;
      icon = Icons.check_circle_outline;
      break;
    case ToastType.complete:
      bgColor = kGreenComplete;
      icon = Icons.task_alt;
      break;
    case ToastType.warning:
      bgColor = kYellow;
      icon = Icons.warning_amber_rounded;
      break;
    case ToastType.error:
      bgColor = kRed;
      icon = Icons.error_outline;
      break;
  }

  // Widget toast custom
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    margin: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: bgColor.withOpacity(0.95),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
  );
}
