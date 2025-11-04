import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../../data/models/user/region.dart';
import '../../../data/services/auth_service.dart';
import '../cubit/wilayah_cubit.dart';
import 'custom_textfield.dart';
import 'wilayah_dropdown.dart';

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

  // controller
  final namaCtrl = TextEditingController();
  final namaUsahaCtrl = TextEditingController();
  final alamatCtrl = TextEditingController();
  final nomorCtrl = TextEditingController();
  final referralCtrl = TextEditingController();

  List<Region> provinsi = [];
  List<Region> kabupaten = [];
  List<Region> kecamatan = [];

  @override
  void initState() {
    super.initState();
    context.read<WilayahCubit>().fetchProvinsi();
  }

  void toggleRegisterCheckbox(bool? value) {
    setState(() => isChecked = value ?? false);
  }

  Future<void> doRegister() async {
    if (namaCtrl.text.trim().isEmpty ||
        alamatCtrl.text.trim().isEmpty ||
        nomorCtrl.text.trim().isEmpty ||
        selectedProvinsi == null ||
        selectedKabupaten == null ||
        selectedKecamatan == null) {
      showAppToast(context, 'Semua data wajib diisi', ToastType.warning);
      return;
    }

    if (!isChecked) {
      showAppToast(
        context,
        'Setujui syarat & ketentuan terlebih dahulu',
        ToastType.error,
      );
      return;
    }

    setState(() => loading = true);

    final namaProvinsi = provinsi
        .firstWhere(
          (p) => p.kode == selectedProvinsi,
          orElse: () => Region(kode: '', nama: ''),
        )
        .nama;
    final namaKabupaten = kabupaten
        .firstWhere(
          (k) => k.kode == selectedKabupaten,
          orElse: () => Region(kode: '', nama: ''),
        )
        .nama;
    final namaKecamatan = kecamatan
        .firstWhere(
          (k) => k.kode == selectedKecamatan,
          orElse: () => Region(kode: '', nama: ''),
        )
        .nama;

    try {
      final result = await authService.onRegisterUser(
        namaUsahaCtrl.text.trim(),
        namaCtrl.text.trim(),
        nomorCtrl.text.trim(),
        alamatCtrl.text.trim(),
        namaProvinsi,
        namaKabupaten,
        namaKecamatan,
        referralCtrl.text.trim().isEmpty ? 'DAFTAR' : referralCtrl.text.trim(),
      );

      if (!mounted) return;
      if (result["success"]) {
        Navigator.pushReplacementNamed(
          context,
          '/kodeOTP',
          arguments: {
            "kode_reseller_register": result["kode_reseller"],
            "type": result["data"]["type"],
            "nomor": result["data"]["nomor"],
            "expiresAt": result["data"]["expiresAt"],
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
    final result = await Navigator.pushNamed(context, '/S&KPage');
    if (result is bool && result && mounted) {
      setState(() => isChecked = result);
      showAppToast(
        context,
        'Syarat dan Ketentuan disetujui',
        ToastType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WilayahCubit, WilayahState>(
      listener: (context, state) {
        if (state is WilayahLoaded) {
          if (selectedProvinsi == null) {
            setState(() => provinsi = state.data);
          } else if (selectedKabupaten == null) {
            setState(() => kabupaten = state.data);
          } else {
            setState(() => kecamatan = state.data);
          }
        } else if (state is WilayahError) {
          showAppToast(context, state.message, ToastType.error);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: namaUsahaCtrl,
              labelText: 'Nama usaha',
              prefixIcon: Icon(Icons.store, color: kOrangeAccent400),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: namaCtrl,
              labelText: 'Nama lengkap',
              prefixIcon: Icon(Icons.person, color: kOrangeAccent400),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: alamatCtrl,
              labelText: 'Alamat lengkap',
              prefixIcon: Icon(Icons.location_on, color: kOrangeAccent400),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 16),

            //dropdown
            WilayahDropdowns(
              provinsi: provinsi,
              kabupaten: kabupaten,
              kecamatan: kecamatan,
              selectedProvinsi: selectedProvinsi,
              selectedKabupaten: selectedKabupaten,
              selectedKecamatan: selectedKecamatan,
              onProvinsiChanged: (value) {
                setState(() {
                  selectedProvinsi = value;
                  selectedKabupaten = null;
                  selectedKecamatan = null;
                  kabupaten.clear();
                  kecamatan.clear();
                });
                context.read<WilayahCubit>().fetchKabupaten(value!);
              },
              onKabupatenChanged: (value) {
                setState(() {
                  selectedKabupaten = value;
                  selectedKecamatan = null;
                  kecamatan.clear();
                });
                context.read<WilayahCubit>().getKecamatan(
                  selectedProvinsi!,
                  value!,
                );
              },
              onKecamatanChanged: (value) {
                setState(() => selectedKecamatan = value);
              },
            ),

            const SizedBox(height: 16),
            CustomTextField(
              controller: nomorCtrl,
              labelText: 'Nomor Whatsapp',
              keyboardType: TextInputType.phone,
              textFormater: [FilteringTextInputFormatter.digitsOnly],
              prefixIcon: Icon(Icons.phone, color: kOrangeAccent400),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: referralCtrl,
              labelText: 'Kode Referral (opsional)',
              prefixIcon: Icon(Icons.code, color: kOrangeAccent400),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: toggleRegisterCheckbox,
                  activeColor: kOrange,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'Dengan mendaftar, Anda setuju dengan ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'syarat dan ketentuan',
                          style: TextStyle(
                            color: kOrange,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = navigateToSnKPage,
                        ),
                        const TextSpan(text: ' yang berlaku.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loading ? null : doRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: isChecked ? kOrange : kNeutral40,
                minimumSize: const Size(double.infinity, 50),
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
      ),
    );
  }

  @override
  void dispose() {
    namaCtrl.dispose();
    namaUsahaCtrl.dispose();
    alamatCtrl.dispose();
    nomorCtrl.dispose();
    referralCtrl.dispose();
    super.dispose();
  }
}
