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
  List<Region> provinsi = [];
  List<Region> kabupaten = [];
  List<Region> kecamatan = [];

  void toggleRegisterCheckbox(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  void doRegister() async {
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

    // Cari nama wilayah berdasarkan kode yang dipilih
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
        alamatLengkapCtrl.text.trim(),
        namaProvinsi,
        namaKabupaten,
        namaKecamatan,
        kodeReferralCtrl.text.trim().isEmpty
            ? 'DAFTAR'
            : kodeReferralCtrl.text.trim(),
      );

      if (!mounted) return;
      if (result["success"]) {
        Navigator.pushReplacementNamed(
          context,
          '/kodeOTP',
          arguments: {
            "kode_reseller_register": result["data"]["kode_reseller"],
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

    if (result is bool) {
      setState(() {
        isChecked = result;
      });
      if (result == true) {
        showAppToast(
          context,
          'Syarat dan Ketentuan telah disetujui.',
          ToastType.success,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<WilayahCubit>().fetchProvinsi();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WilayahCubit, WilayahState>(
      listener: (context, state) {
        if (state is WilayahLoaded) {
          // Jika belum ada provinsi yang dipilih, berarti data ini adalah untuk provinsi.
          if (selectedProvinsi == null) {
            setState(() => provinsi = state.data);
          }
          // Jika provinsi sudah dipilih tapi kabupaten belum, berarti data ini untuk kabupaten.
          else if (selectedProvinsi != null && selectedKabupaten == null) {
            setState(() => kabupaten = state.data);
          }
          // Jika provinsi dan kabupaten sudah dipilih, berarti data ini untuk kecamatan.
          else if (selectedProvinsi != null && selectedKabupaten != null) {
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
            BlocBuilder<WilayahCubit, WilayahState>(
              builder: (context, state) {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Provinsi',
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
                  initialValue: selectedProvinsi,
                  isExpanded: true,
                  items: provinsi
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.kode,
                          child: Text(e.nama),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProvinsi = value;
                      selectedKabupaten = null;
                      selectedKecamatan = null;
                      kabupaten.clear();
                      kecamatan.clear();
                    });
                    if (value != null) {
                      context.read<WilayahCubit>().fetchKabupaten(value);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<WilayahCubit, WilayahState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<String>(
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
                            borderSide: BorderSide(
                              color: kOrangeAccent500,
                              width: 2,
                            ),
                          ),
                        ),
                        initialValue: selectedKabupaten,
                        isExpanded: true,
                        items: kabupaten
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.kode,
                                child: Text(e.nama),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedKabupaten = value;
                            selectedKecamatan = null;
                            kecamatan.clear();
                          });
                          if (selectedProvinsi != null && value != null) {
                            context.read<WilayahCubit>().getKecamatan(
                              selectedProvinsi!,
                              value,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: BlocBuilder<WilayahCubit, WilayahState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<String>(
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
                            borderSide: BorderSide(
                              color: kOrangeAccent500,
                              width: 2,
                            ),
                          ),
                        ),
                        initialValue: selectedKecamatan,
                        items: kecamatan
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.kode,
                                child: Text(e.nama),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedKecamatan = value);
                        },
                        isDense: true,
                        isExpanded: true,
                        menuMaxHeight: 200,
                      );
                    },
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
              onPressed: loading ? null : doRegister,
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
