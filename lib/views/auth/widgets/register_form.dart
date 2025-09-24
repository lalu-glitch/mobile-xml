import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/error_dialog.dart';
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

  bool isRegisterChecked = false;
  String? selectedProvince;
  String? selectedRegency;
  String? selectedDistrict;

  //controller
  final namaCtrl = TextEditingController();
  final namaUsahaCtrl = TextEditingController();
  final alamatLengkapCtrl = TextEditingController();
  final nomorCtrl = TextEditingController();
  final kodeReferralCtrl = TextEditingController();

  // Placeholder data untuk dropdown
  final List<String> provinces = ['Jawa Barat', 'Jawa Tengah', 'Jawa Timur'];
  final List<String> regencies = ['Bandung', 'Cimahi', 'Garut'];
  final List<String> districts = [
    'Cibaduyut',
    'Cihampelas',
    'Cicalengka',
    'Ciamis',
  ];

  void toggleRegisterCheckbox(bool? value) {
    setState(() {
      isRegisterChecked = value ?? false;
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
        selectedProvince == null ||
        selectedRegency == null ||
        selectedDistrict == null) {
      showInfoToast('Semua data wajib diisi, kecuali kode referral', kRed);
      return;
    }

    if (!isRegisterChecked) {
      showInfoToast('Anda harus menyetujuan syarat dan ketentuan', kRed);
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
            value: selectedProvince,
            // hint: Text('Provinsi'),
            items: provinces.map((String province) {
              return DropdownMenuItem<String>(
                value: province,
                child: Text(province),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedProvince = newValue;
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
                  value: selectedDistrict,
                  items: districts.map((String district) {
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
                      selectedDistrict = newValue;
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
                  value: selectedRegency,
                  items: regencies.map((String regency) {
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
                      selectedRegency = newValue;
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
            prefixIcon: Icon(Icons.phone, color: kOrangeAccent400),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: kodeReferralCtrl,
            labelText: 'Kode Refferal (opsional)',
            prefixIcon: Icon(Icons.code, color: kOrangeAccent400),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: isRegisterChecked,
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
                          fontWeight: FontWeight.bold,
                        ),
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
                      selectedProvince!,
                      selectedRegency!,
                      selectedDistrict!,
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isRegisterChecked ? kOrange : kNeutral40,
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
