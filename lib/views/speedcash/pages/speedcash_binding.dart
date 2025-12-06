import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../../data/services/speedcash_api_service.dart';
import '../../../data/services/auth_service.dart';
import '../../settings/cubit/info_akun/info_akun_cubit.dart';
import '../cubit/speedcash_binding_cubit.dart';

class SpeedcashBindingPage extends StatelessWidget {
  SpeedcashBindingPage({super.key});
  final _phoneCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //scope provider aja
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
            final data = state.data;

            // Jika ada redirect URL → buka WebView
            if (data.redirectUrl.isNotEmpty) {
              Navigator.pushNamed(
                context,
                '/webviewSpeedcash',
                arguments: {
                  'url': data.redirectUrl,
                  'title': 'Binding Speedcash',
                },
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: kBackground,
          appBar: AppBar(
            title: const Text(
              'Speedcash Binding',
              style: TextStyle(color: kWhite, fontWeight: .bold),
            ),
            leading: BackButton(onPressed: () => Navigator.pop(context)),
            backgroundColor: kOrange,
            iconTheme: const IconThemeData(color: kWhite),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 1,
                color: kWhite,
                shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/images/logo-speedcash.png',
                        width: 256,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 24),

                      // Phone Input
                      TextField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Nomor HP",
                          prefixIcon: const Icon(Icons.phone, color: kOrange),
                          filled: true,
                          fillColor: kOrange.withAlpha(25),
                          border: OutlineInputBorder(
                            borderRadius: .circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      BlocBuilder<SpeedcashBindingCubit, SpeedcashBindingState>(
                        builder: (context, state) {
                          final isLoading = state is SpeedcashBindingLoading;

                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      final phone = _phoneCtrl.text.trim();

                                      if (phone.isEmpty) {
                                        showErrorDialog(
                                          context,
                                          'Nomor HP tidak boleh kosong',
                                        );
                                        return;
                                      }

                                      // ambil kode reseller dari InfoAkunCubit
                                      final kodeReseller = switch (context
                                          .read<InfoAkunCubit>()
                                          .state) {
                                        InfoAkunLoaded s =>
                                          s.data.data.kodeReseller,
                                        _ => '',
                                      };

                                      context
                                          .read<SpeedcashBindingCubit>()
                                          .speedcashBinding(
                                            kodeReseller,
                                            phone,
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(16),
                                ),
                                backgroundColor: kOrange,
                                elevation: 1,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: kWhite,
                                      ),
                                    )
                                  : Text(
                                      "Bind Speedcash",
                                      style: TextStyle(
                                        fontSize: kSize18,
                                        fontWeight: .w600,
                                        color: kWhite,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/speedcashRegisterPage',
                          );
                        },
                        child: const Text(
                          "Belum punya akun? Buat di sini.",
                          style: TextStyle(color: kOrange),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
