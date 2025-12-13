import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/custom_textfield.dart';
import '../../../core/utils/dialog.dart';
import '../../../data/services/speedcash_api_service.dart';
import '../../../data/services/auth_service.dart';
import '../../settings/cubit/info_akun/info_akun_cubit.dart';
import '../cubit/speedcash_binding_cubit.dart';

class SpeedcashBindingPage extends StatefulWidget {
  SpeedcashBindingPage({super.key});

  @override
  State<SpeedcashBindingPage> createState() => _SpeedcashBindingPageState();
}

class _SpeedcashBindingPageState extends State<SpeedcashBindingPage> {
  // Controller diinisialisasi di sini (Stateless) atau convert ke Stateful jika butuh dispose
  final _phoneCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpeedcashBindingCubit(
        SpeedcashApiService(authService: AuthService()),
      ),
      child: BlocListener<SpeedcashBindingCubit, SpeedcashBindingState>(
        listener: (context, state) {
          if (state is SpeedcashBindingError) {
            showErrorDialog(context, state.message);
          }
          if (state is SpeedcashBindingSuccess) {
            if (state.data.redirectUrl.isNotEmpty) {
              Navigator.pushNamed(
                context,
                '/webviewSpeedcash',
                arguments: {
                  'url': state.data.redirectUrl,
                  'title': 'Binding Speedcash',
                },
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: kOrange, // Warna background atas
          appBar: AppBar(
            backgroundColor: kOrange,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: kWhite,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Hubungkan Akun',
              style: const TextStyle(
                color: kWhite,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              const SizedBox(height: 30),

              // --- Bottom Sheet Section (Form) ---
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kBackground, // atau kWhite
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Masukkan Nomor HP",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kBlack,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Pastikan nomor Handphone Anda sudah terdaftar di layanan Speedcash.",
                          style: const TextStyle(
                            fontSize: 13,
                            color: kNeutral80, // Warna abu-abu soft
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- Input Field (Existing) ---
                        FintechInputField(
                          controller: _phoneCtrl,
                          label: 'Nomor Handphone',
                          hint: 'Contoh: 08123456789',
                          icon: Icons.phone_iphone_rounded,
                        ),

                        const SizedBox(height: 32),

                        // --- Action Button ---
                        BlocBuilder<
                          SpeedcashBindingCubit,
                          SpeedcashBindingState
                        >(
                          builder: (context, state) {
                            final isLoading = state is SpeedcashBindingLoading;

                            return SizedBox(
                              width: double.infinity,
                              height: 52, // Tinggi standar tombol mobile modern
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        _onBindPressed(context);
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kOrange,
                                  foregroundColor: kWhite,
                                  elevation: 0, // Flat design lebih modern
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: kWhite,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        "Hubungkan Sekarang",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // --- Footer (Register Link) ---
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/speedcashRegisterPage',
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: "Belum memiliki akun? ",
                                style: const TextStyle(
                                  color: kNeutral80,
                                  fontSize: 13,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Daftar di sini",
                                    style: const TextStyle(
                                      color: kOrange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Spacer aman untuk keyboard
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // dipisah agar Build method bersih
  void _onBindPressed(BuildContext context) {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      showErrorDialog(context, 'Nomor HP wajib diisi');
      return;
    }

    // Pattern matching modern untuk ambil data state
    final infoState = context.read<InfoAkunCubit>().state;
    final kodeReseller = switch (infoState) {
      InfoAkunLoaded s => s.data.data.kodeReseller,
      _ => '',
    };

    context.read<SpeedcashBindingCubit>().speedcashBinding(kodeReseller, phone);
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }
}
