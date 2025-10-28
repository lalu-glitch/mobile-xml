import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../../data/services/auth_service.dart';
import 'custom_textfield.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final authService = AuthService();
  bool loading = false;

  bool isChecked = false;
  String? selectedProvinsi;
  String? selectedKabupaten;
  String? selectedKecamatan;

  //controller
  final namaCtrl = TextEditingController();
  final namaUsahaCtrl = TextEditingController();
  final alamatLengkapCtrl = TextEditingController();
  final nomorCtrl = TextEditingController();
  final kodeReferralCtrl = TextEditingController();

  // Placeholder data  dropdown
  final List<String> provinsi = ['Jawa Barat', 'Jawa Tengah', 'Jawa Timur'];
  final List<String> kabupaten = ['Bandung', 'Cimahi', 'Garut'];
  final List<String> kecamatan = [
    'Cibaduyut',
    'Cihampelas',
    'Cicalengka',
    'Ciamis',
  ];

  void toggleRegisterCheckbox(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  void doRegister(String provinsi, String kabupaten, String kecamatan) async {
    final nama = namaCtrl.text.trim();
    final namaUsaha = namaUsahaCtrl.text.trim();
    final alamat = alamatLengkapCtrl.text.trim();
    final nomor = nomorCtrl.text.trim();
    final referral = kodeReferralCtrl.text.trim();

    if (namaCtrl.text.trim().isEmpty ||
        alamatLengkapCtrl.text.trim().isEmpty ||
        nomorCtrl.text.trim().isEmpty ||
        selectedProvinsi == null ||
        selectedKabupaten == null ||
        selectedKecamatan == null) {
      showAppToast(
        context,
        'Semua data wajib diisi, kecuali kode referral',
        ToastType.warning,
      );
      return;
    }

    if (!isChecked) {
      showAppToast(
        context,
        'Anda harus menyetujui syarat dan ketentuan',
        ToastType.error,
      );
      return;
    }

    setState(() => loading = true);

    try {
      final result = await authService.onRegisterUser(
        namaUsaha,
        nama,
        nomor,
        alamat,
        provinsi,
        kabupaten,
        kecamatan,
        referral.isEmpty ? 'DAFTAR' : referral,
      );

      if (!mounted) return;
      if (result["success"]) {
        Navigator.pushReplacementNamed(
          context,
          '/kodeOTP',
          arguments: {
            "kodeAgen": result["data"]["data"]["kode_reseller"],
            "type": result["data"]["data"]["type"],
            "nomor": result["data"]["data"]["nomor"],
            "expiresAt": result["data"]['data']["expiresAt"],
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, "Terjadi kesalahan register: $e");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void navigateToSnKPage() async {
    // Use the route name you have defined, e.g., '/S&KPage'
    final result = await Navigator.pushNamed(context, '/S&KPage');

    // Check if a boolean result was returned (true if agreed, false if declined/back)
    if (result is bool) {
      setState(() {
        // Update isChecked state directly with the result from the T&C page
        isChecked = result;
      });
      if (result == true) {
        // Optional: Show success toast if agreed
        showAppToast(
          context,
          'Syarat dan Ketentuan telah disetujui.',
          ToastType.success,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextField(
            controller: namaUsahaCtrl,
            labelText: 'Nama usaha',
            prefixIcon: Icon(Icons.store, color: kOrangeAccent400),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: namaCtrl,
            labelText: 'Nama lengkap',
            prefixIcon: Icon(Icons.person, color: kOrangeAccent400),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: alamatLengkapCtrl,
            labelText: 'Alamat',
            prefixIcon: Icon(Icons.location_on, color: kOrangeAccent400),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.map, color: kOrangeAccent400, size: 20),
              labelText: 'Provinsi',
              labelStyle: TextStyle(color: kNeutral80),
              floatingLabelStyle: TextStyle(color: kOrange),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: kOrangeAccent500),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: kOrangeAccent500),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: kOrangeAccent500, width: 2),
              ),
            ),
            initialValue: selectedProvinsi,
            items: provinsi.map((String province) {
              return DropdownMenuItem<String>(
                value: province,
                child: Text(province),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedProvinsi = newValue;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Kecamatan',
                    labelStyle: TextStyle(color: kNeutral80),
                    floatingLabelStyle: TextStyle(color: kOrange),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kOrangeAccent500),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kOrangeAccent500),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kOrangeAccent500, width: 2),
                    ),
                  ),
                  initialValue: selectedKecamatan,
                  items: kecamatan.map((String district) {
                    return DropdownMenuItem<String>(
                      value: district,
                      child: Text(
                        district,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedKecamatan = newValue;
                    });
                  },
                  isDense: true,
                  isExpanded: true,
                  menuMaxHeight: 200,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Kabupaten',
                    labelStyle: TextStyle(color: kNeutral80),
                    floatingLabelStyle: TextStyle(color: kOrange),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kOrangeAccent500),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kOrangeAccent500),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kOrangeAccent500, width: 2),
                    ),
                  ),
                  initialValue: selectedKabupaten,
                  items: kabupaten.map((String regency) {
                    return DropdownMenuItem<String>(
                      value: regency,
                      child: Text(
                        regency,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedKabupaten = newValue;
                    });
                  },
                  isDense: true,
                  isExpanded: true,
                  menuMaxHeight: 200,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: nomorCtrl,
            labelText: 'Nomor Whatsapp',
            textFormater: [FilteringTextInputFormatter.digitsOnly],
            prefixIcon: Icon(Icons.phone, color: kOrangeAccent400),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: kodeReferralCtrl,
            labelText: 'Kode Referral (opsional)',
            prefixIcon: Icon(Icons.code, color: kOrangeAccent400),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: toggleRegisterCheckbox,
                activeColor: kOrange,
                checkColor: kWhite,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Dengan mendaftar, Anda telah setuju dengan ',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'syarat dan ketentuan',
                        style: TextStyle(
                          color: kOrange,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigateToSnKPage();
                          },
                      ),

                      TextSpan(text: ' yang berlaku.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: loading
                ? null
                : () {
                    doRegister(
                      selectedProvinsi ?? '',
                      selectedKabupaten ?? '',
                      selectedKecamatan ?? '',
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isChecked ? kOrange : kNeutral40,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Daftar',
              style: TextStyle(color: kWhite, fontSize: 16),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  @override
  void dispose() {
    namaUsahaCtrl.dispose();
    namaCtrl.dispose();
    alamatLengkapCtrl.dispose();
    nomorCtrl.dispose();
    kodeReferralCtrl.dispose();
    super.dispose();
  }
}
