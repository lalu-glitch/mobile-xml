import 'package:flutter/material.dart';

import '../../../core/utils/dialog.dart';
import '../../../data/models/user/region_model.dart';

class RegisterFormController {
  final TextEditingController namaCtrl;
  final TextEditingController namaUsahaCtrl;
  final TextEditingController alamatCtrl;
  final TextEditingController nomorCtrl;
  final TextEditingController referralCtrl;

  RegisterFormController({
    required this.namaCtrl,
    required this.namaUsahaCtrl,
    required this.alamatCtrl,
    required this.nomorCtrl,
    required this.referralCtrl,
  });

  bool validateInputs({
    required bool isChecked,
    required String? provinsi,
    required String? kabupaten,
    required String? kecamatan,
    required BuildContext context,
  }) {
    if (namaCtrl.text.trim().isEmpty ||
        alamatCtrl.text.trim().isEmpty ||
        nomorCtrl.text.trim().isEmpty ||
        provinsi == null ||
        kabupaten == null ||
        kecamatan == null) {
      showAppToast(context, 'Semua data wajib diisi', ToastType.warning);
      return false;
    }

    if (!isChecked) {
      showAppToast(
        context,
        'Setujui syarat & ketentuan terlebih dahulu',
        ToastType.error,
      );
      return false;
    }

    return true;
  }

  String resolveName(List<Region> list, String? kode) {
    return list
        .firstWhere(
          (e) => e.kode == kode,
          orElse: () => Region(kode: '', nama: ''),
        )
        .nama;
  }
}
