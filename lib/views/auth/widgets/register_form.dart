import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../../data/models/user/region.dart';
import '../cubit/register_cubit.dart';
import '../cubit/wilayah_cubit.dart';
import '../helper/register_controller.dart';
import 'custom_textfield.dart';
import 'wilayah_dropdown.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  late final RegisterFormController controller;
  bool loading = false;
  bool isChecked = false;

  String? selectedProvinsi;
  String? selectedKabupaten;
  String? selectedKecamatan;

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

    controller = RegisterFormController(
      namaCtrl: namaCtrl,
      namaUsahaCtrl: namaUsahaCtrl,
      alamatCtrl: alamatCtrl,
      nomorCtrl: nomorCtrl,
      referralCtrl: referralCtrl,
    );

    context.read<WilayahCubit>().fetchProvinsi();
  }

  /// register
  Future<void> doRegister() async {
    if (!controller.validateInputs(
      isChecked: isChecked,
      provinsi: selectedProvinsi,
      kabupaten: selectedKabupaten,
      kecamatan: selectedKecamatan,
      context: context,
    )) {
      return;
    }

    final provName = controller.resolveName(provinsi, selectedProvinsi);
    final kabName = controller.resolveName(kabupaten, selectedKabupaten);
    final kecName = controller.resolveName(kecamatan, selectedKecamatan);

    context.read<RegisterCubit>().registerUser(
      namaUsaha: namaUsahaCtrl.text.trim(),
      namaLengkap: namaCtrl.text.trim(),
      nomor: nomorCtrl.text.trim(),
      alamat: alamatCtrl.text.trim(),
      provinsi: provName,
      kabupaten: kabName,
      kecamatan: kecName,
      referral: referralCtrl.text.trim().isEmpty
          ? 'DAFTAR'
          : referralCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // LISTEN WILAYAH
        BlocListener<WilayahCubit, WilayahState>(
          listener: (context, state) {
            if (state is WilayahLoaded) {
              setState(() {
                if (selectedProvinsi == null) {
                  provinsi = state.data;
                } else if (selectedKabupaten == null) {
                  kabupaten = state.data;
                } else {
                  kecamatan = state.data;
                }
              });
            } else if (state is WilayahError) {
              showAppToast(
                context,
                'Terjadi kesalahan dari server',
                ToastType.error,
              );
            }
          },
        ),

        // LISTEN REGISTER RESULT
        BlocListener<RegisterCubit, RegisterState>(
          listener: (_, state) {
            if (state is RegisterLoading) {
              setState(() => loading = true);
            } else if (state is RegisterSuccess) {
              setState(() => loading = false);

              Navigator.pushReplacementNamed(
                context,
                '/kodeOTP',
                arguments: {
                  "kode_reseller_register": state.data["kode_reseller"],
                  "type": state.data["type"],
                  "nomor": state.data["nomor"],
                  "expiresAt": state.data["expiresAt"],
                },
              );
            } else if (state is RegisterError) {
              setState(() => loading = false);

              showErrorDialog(context, "Kesalahan register: ${state.message}");
            }
          },
        ),
      ],
      child: _buildFormUI(),
    );
  }

  Widget _buildFormUI() {
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
            controller: alamatCtrl,
            labelText: 'Alamat lengkap',
            prefixIcon: Icon(Icons.location_on, color: kOrangeAccent400),
          ),
          const SizedBox(height: 16),

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
          ),
          const SizedBox(height: 16),

          CustomTextField(
            controller: referralCtrl,
            labelText: 'Kode Referral (opsional)',
            prefixIcon: Icon(Icons.code, color: kOrangeAccent400),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (v) => setState(() => isChecked = v ?? false),
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
                          ..onTap = () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/S&KPage',
                            );
                            if (result == true) {
                              setState(() => isChecked = true);
                              showAppToast(
                                context,
                                'Syarat & Ketentuan disetujui',
                                ToastType.success,
                              );
                            }
                          },
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
            child: loading
                ? CircularProgressIndicator(color: kWhite)
                : Text('Daftar', style: TextStyle(color: kWhite, fontSize: 16)),
          ),

          const SizedBox(height: 50),
        ],
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
