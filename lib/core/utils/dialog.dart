import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../helper/constant_finals.dart';

Future<void> showErrorDialog(BuildContext context, String message) {
  // Explicit <void> untuk clarity
  return showDialog<void>(
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

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onOk;

  const SuccessDialog({
    super.key,
    this.title = "Berhasil",
    required this.message,
    this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kGreenComplete,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 55),
          ),
          const SizedBox(height: 25),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kSupaBlack,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 15, height: 1.4, color: kNeutral90),
        textAlign: TextAlign.center,
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              if (onOk != null) onOk!();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              foregroundColor: kWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
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
    width: double.infinity,
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

Future<bool> showExitDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ikon keluar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    "Keluar Aplikasi?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kRed,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Message
                  const Text(
                    "Apakah kamu yakin ingin keluar?",
                    style: TextStyle(fontSize: 14, color: kBlack),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Tombol
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(
                            "Tidak",
                            style: TextStyle(color: kBlack),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kRed,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => exit(0),
                          child: const Text(
                            "Ya",
                            style: TextStyle(color: kWhite),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ) ??
      false;
}

Future<bool> showForceExitDialog(
  BuildContext context,
  VoidCallback onConfirm,
) async {
  return await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ikon keluar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Icon(
                        Icons.warning_rounded,
                        color: Colors.red,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    const Text(
                      "Perhatian",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kRed,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Message
                    const Text(
                      "Sesi Anda telah habis, silahkan login ulang",
                      style: TextStyle(fontSize: 14, color: kBlack),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Tombol
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kRed,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          onConfirm();
                          Navigator.pushReplacementNamed(context, '/authPage');
                        },
                        child: const Text(
                          "Ya",
                          style: TextStyle(color: kWhite),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ) ??
      false;
}
