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

  final namaCtrl = TextEditingController();
  final namaUsahaCtrl = TextEditingController();
  final alamatLengkapCtrl = TextEditingController();
  final nomorCtrl = TextEditingController();
  final kodeReferralCtrl = TextEditingController();

  List<Region> provinsi = [];
  List<Region> kabupaten = [];
  List<Region> kecamatan = [];

  @override
  void initState() {
    super.initState();
    context.read<WilayahCubit>().fetchProvinsi();
  }

  void toggleRegisterCheckbox(bool? value) =>
      setState(() => isChecked = value ?? false);

  void navigateToSnKPage() async {
    final result = await Navigator.pushNamed(context, '/S&KPage');
    if (result is bool) {
      setState(() => isChecked = result);
      if (result) {
        showAppToast(
          context,
          'Syarat dan Ketentuan telah disetujui.',
          ToastType.success,
        );
      }
    }
  }

  void doRegister(String provinsi, String kabupaten, String kecamatan) async {
    if (_isFormInvalid()) return;

    setState(() => loading = true);
    try {
      final result = await authService.onRegisterUser(
        namaUsahaCtrl.text.trim(),
        namaCtrl.text.trim(),
        nomorCtrl.text.trim(),
        alamatLengkapCtrl.text.trim(),
        provinsi,
        kabupaten,
        kecamatan,
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
            "kodeAgen": result["data"]["data"]["kode_reseller"],
            "type": result["data"]["data"]["type"],
            "nomor": result["data"]["data"]["nomor"],
            "expiresAt": result["data"]["data"]["expiresAt"],
          },
        );
      }
    } catch (e) {
      if (mounted) showErrorDialog(context, "Terjadi kesalahan register: $e");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  bool _isFormInvalid() {
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
      return true;
    }
    if (!isChecked) {
      showAppToast(
        context,
        'Anda harus menyetujui syarat dan ketentuan',
        ToastType.error,
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WilayahCubit, WilayahState>(
      listener: (context, state) {
        if (state is WilayahLoaded) {
          setState(() {
            if (selectedProvinsi == null)
              provinsi = state.data;
            else if (selectedKabupaten == null)
              kabupaten = state.data;
            else
              kecamatan = state.data;
          });
        } else if (state is WilayahError) {
          showAppToast(context, state.message, ToastType.error);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTextField(namaUsahaCtrl, 'Nama usaha', Icons.store),
            _gap(),
            _buildTextField(namaCtrl, 'Nama lengkap', Icons.person),
            _gap(),
            _buildTextField(alamatLengkapCtrl, 'Alamat', Icons.location_on),
            _gap(),

            // Provinsi
            _WilayahDropdown(
              label: 'Provinsi',
              value: selectedProvinsi,
              items: provinsi,
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
            ),
            _gap(),

            // Kabupaten & Kecamatan
            Row(
              children: [
                Expanded(
                  child: _WilayahDropdown(
                    label: 'Kabupaten',
                    value: selectedKabupaten,
                    items: kabupaten,
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
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _WilayahDropdown(
                    label: 'Kecamatan',
                    value: selectedKecamatan,
                    items: kecamatan,
                    onChanged: (value) {
                      setState(() => selectedKecamatan = value);
                    },
                  ),
                ),
              ],
            ),
            _gap(),
            _buildTextField(
              nomorCtrl,
              'Nomor Whatsapp',
              Icons.phone,
              keyboardType: TextInputType.phone,
              formatter: [FilteringTextInputFormatter.digitsOnly],
            ),
            _gap(),
            _buildTextField(
              kodeReferralCtrl,
              'Kode Referral (opsional)',
              Icons.code,
            ),
            const SizedBox(height: 24),
            _buildAgreementSection(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);

  Widget _buildTextField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatter,
  }) {
    return CustomTextField(
      controller: ctrl,
      labelText: label,
      prefixIcon: Icon(icon, color: kOrangeAccent400),
      keyboardType: keyboardType,
      textFormater: formatter,
    );
  }

  Widget _buildAgreementSection() {
    return Row(
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
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(
                  text: 'syarat dan ketentuan',
                  style: const TextStyle(
                    color: kOrange,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = navigateToSnKPage,
                ),
                const TextSpan(text: ' yang berlaku.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: loading
          ? null
          : () => doRegister(
              selectedProvinsi ?? '',
              selectedKabupaten ?? '',
              selectedKecamatan ?? '',
            ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isChecked ? kOrange : kNeutral40,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: const Text(
        'Daftar',
        style: TextStyle(color: kWhite, fontSize: 16),
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

// Widget Reusable Dropdown Wilayah
class _WilayahDropdown extends StatelessWidget {
  const _WilayahDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<Region> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kNeutral80),
        floatingLabelStyle: const TextStyle(color: kOrange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kOrangeAccent500),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kOrangeAccent500),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kOrangeAccent500, width: 2),
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e.kode,
              child: Text(e.nama, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
