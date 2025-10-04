import 'package:flutter/material.dart';

import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

import '../../core/utils/dialog.dart';

class ContactFlowHandler {
  final BuildContext context;
  final TextEditingController nomorController;
  final Function(VoidCallback fn)
  setStateCallback; // buat nerima  setState dari State

  final FlutterNativeContactPicker contactPicker = FlutterNativeContactPicker();

  ContactFlowHandler({
    required this.context,
    required this.nomorController,
    required this.setStateCallback,
  });

  Future<void> pickContact() async {
    try {
      Contact? contact = await contactPicker.selectPhoneNumber();

      // Cek mounted dilakukan di dalam page sebelum memanggil handler
      // Tapi kita cek lagi untuk keamanan setelah await
      if (contact != null && contact.selectedPhoneNumber != null) {
        setStateCallback(() {
          // Menggunakan setStateCallback yang diberikan
          // Hanya ambil digit
          nomorController.text = contact.selectedPhoneNumber!.replaceAll(
            RegExp(r'\D'),
            '',
          );
        });
      } else {
        // Tampilkan pesan gagal (menggunakan context yang diberikan)
        showAppToast(
          context,
          'Kontak tidak memiliki nomor telepon yang valid.',
          ToastType.warning,
        );
      }
    } catch (e) {
      showAppToast(
        context,
        'Gagal memilih kontak. Pastikan izin telah diberikan.',
        ToastType.error,
      );
    }
  }
}
