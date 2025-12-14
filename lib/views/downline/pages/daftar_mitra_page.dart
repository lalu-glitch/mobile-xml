import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/custom_textfield.dart';
import '../../../core/utils/dialog.dart';
import '../../settings/cubit/info_akun/info_akun_cubit.dart';
import '../cubit/daftar_mitra_cubit.dart';

class DaftarMitraPage extends StatefulWidget {
  const DaftarMitraPage({super.key});

  @override
  State<DaftarMitraPage> createState() => _DaftarMitraPageState();
}

class _DaftarMitraPageState extends State<DaftarMitraPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _nomorController = TextEditingController();
  final _markupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kOrange,
        centerTitle: true,
        title: const Text(
          'Registrasi Mitra',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<DaftarMitraCubit, DaftarMitraState>(
        listener: (context, state) {
          if (state is DaftarMitraLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: CircularProgressIndicator(color: kOrange),
              ),
            );
          } else if (state is DaftarMitraSuccess) {
            Navigator.pop(context);
            Navigator.pop(context, true);
            showAppToast(context, state.responseMessage, ToastType.success);
          } else if (state is DaftarMitraError) {
            Navigator.pop(context);
            Navigator.pop(context, true);
            showAppToast(context, state.message, ToastType.error);
          }
        },
        child: SafeArea(
          child: SizedBox.expand(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Mitra',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lengkapi formulir di bawah ini untuk mendaftarkan mitra baru.',
                      style: TextStyle(color: kGrey),
                    ),
                    const SizedBox(height: 24),

                    FintechInputField(
                      controller: _namaController,
                      label: 'Nama Lengkap',
                      hint: 'Contoh: Elon Musk',
                      icon: Icons.person,
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    FintechInputField(
                      controller: _alamatController,
                      label: 'Alamat Lengkap',
                      hint: 'Jl. Jendral Sudirman No. 1...',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Alamat wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    FintechInputField(
                      controller: _nomorController,
                      label: 'Nomor WhatsApp',
                      hint: '0812xxxx',
                      icon: Icons.phone_android_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => v == null || v.length < 10
                          ? 'Nomor tidak valid'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    FintechInputField(
                      controller: _markupController,
                      label: 'Markup Harga',
                      hint: '0',
                      icon: Icons.price_change_outlined,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      helperText: 'Selisih harga jual untuk mitra (Default: 0)',
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kOrange,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: kOrange.withAlpha(100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Daftarkan Mitra',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: .w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    final infoAkunState = context.read<InfoAkunCubit>().state;
    final kodeReseller = switch (infoAkunState) {
      InfoAkunLoaded s => s.data.data.kodeReseller,
      _ => '',
    };
    context.read<DaftarMitraCubit>().daftarMitra(
      nama: _namaController.text.trim(),
      alamat: _alamatController.text.trim(),
      nomor: _nomorController.text.trim(),
      markup: int.tryParse(_markupController.text.trim()) ?? 0,
      kodeReseller: kodeReseller,
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _nomorController.dispose();
    _markupController.dispose();
    super.dispose();
  }
}
