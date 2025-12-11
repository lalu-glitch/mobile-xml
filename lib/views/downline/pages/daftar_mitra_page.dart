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
  // GlobalKey untuk validasi Form yang efisien
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _nomorController = TextEditingController();
  final _markupController = TextEditingController();

  // FocusNodes untuk navigasi keyboard yang mulus (UX)
  final _alamatNode = FocusNode();
  final _nomorNode = FocusNode();
  final _markupNode = FocusNode();

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _nomorController.dispose();
    _markupController.dispose();
    _alamatNode.dispose();
    _nomorNode.dispose();
    _markupNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // 1. Validasi UI dulu sebelum panggil logic (Hemat resource)
    if (!_formKey.currentState!.validate()) return;

    // 2. Ambil data state terbaru langsung saat aksi (Lazy retrieval)
    // Ini lebih aman daripada menyimpan string di state local yang bisa stale
    final infoAkunState = context.read<InfoAkunCubit>().state;
    final kodeReseller = switch (infoAkunState) {
      InfoAkunLoaded s => s.data.data.kodeReseller,
      _ => '',
    };

    // 3. Eksekusi Logic
    context.read<DaftarMitraCubit>().daftarMitra(
      nama: _namaController.text.trim(),
      alamat: _alamatController.text.trim(),
      nomor: _nomorController.text.trim(),
      markup: int.tryParse(_markupController.text.trim()) ?? 0,
      kodeReseller: kodeReseller,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil ukuran layar untuk scaling
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: kBackground, // Background terang ala Fintech modern
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
            Navigator.pop(context); // Tutup Loading
            Navigator.pop(context, true); // Kembali ke halaman sebelumnya
            showAppToast(context, state.responseMessage, ToastType.success);
          } else if (state is DaftarMitraError) {
            Navigator.pop(context); // Tutup Loading
            showAppToast(context, state.message, ToastType.error);
          }
        },
        child: SafeArea(
          child: SizedBox.expand(
            // SingleChildScrollView + ClampingPhysics biar gak bounce berlebih
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
                    // Header Text
                    Text(
                      'Data Mitra',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: kBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lengkapi formulir di bawah ini untuk mendaftarkan mitra baru.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: kGrey),
                    ),
                    const SizedBox(height: 24),

                    // Field Nama
                    FintechInputField(
                      controller: _namaController,
                      label: 'Nama Lengkap',
                      hint: 'Contoh: Elon Musk',
                      icon: Icons.person,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_alamatNode),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    // Field Alamat
                    FintechInputField(
                      controller: _alamatController,
                      focusNode: _alamatNode,
                      label: 'Alamat Lengkap',
                      hint: 'Jl. Jendral Sudirman No. 1...',
                      icon: Icons.location_on_outlined,
                      maxLines: 2, // Alamat butuh space lebih
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_nomorNode),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Alamat wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    // Field Nomor HP
                    FintechInputField(
                      controller: _nomorController,
                      focusNode: _nomorNode,
                      label: 'Nomor WhatsApp',
                      hint: '0812xxxx',
                      icon: Icons.phone_android_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_markupNode),
                      validator: (v) => v == null || v.length < 10
                          ? 'Nomor tidak valid'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Field Markup
                    FintechInputField(
                      controller: _markupController,
                      focusNode: _markupNode,
                      label: 'Markup Harga',
                      hint: '0',
                      icon: Icons.price_change_outlined,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      helperText: 'Selisih harga jual untuk mitra (Default: 0)',
                      onFieldSubmitted: (_) => _onSubmit(),
                    ),

                    const SizedBox(height: 40),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52, // Tinggi standar tombol mobile
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
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
