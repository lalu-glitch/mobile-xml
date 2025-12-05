import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../../data/services/speedcash_api_service.dart';
import '../../../data/services/auth_service.dart';

import '../cubit/speedcash_register_cubit.dart';

class SpeedcashRegisterPage extends StatelessWidget {
  SpeedcashRegisterPage({super.key});

  ///TODO [handle validate]
  final _namaCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpeedcashRegisterCubit(
        SpeedcashApiService(authService: context.read<AuthService>()),
      ),
      child: BlocListener<SpeedcashRegisterCubit, SpeedcashRegisterState>(
        listener: (context, state) {
          if (state is SpeedcashRegisterError) {
            showErrorDialog(context, state.message);
          }

          if (state is SpeedcashRegisterSuccess) {
            final data = state.data;

            // Jika ada redirect URL → buka WebView
            if (data.redirectUrl.isNotEmpty) {
              Navigator.pushNamed(
                context,
                '/webviewSpeedcash',
                arguments: {
                  'url': data.redirectUrl,
                  'title': 'Registrasi Speedcash',
                },
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text(
              'Speedcash Register',
              style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
            ),
            backgroundColor: kOrange,
            iconTheme: const IconThemeData(color: kWhite),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 1,
                color: kWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Logo
                      Image.asset(
                        'assets/images/logo-speedcash.png',
                        width: 256,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 24),

                      /// Nama
                      TextField(
                        controller: _namaCtrl,
                        decoration: InputDecoration(
                          labelText: "Nama",
                          prefixIcon: const Icon(Icons.person, color: kOrange),
                          filled: true,
                          fillColor: kOrange.withAlpha(25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// Phone
                      TextField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone",
                          prefixIcon: const Icon(Icons.phone, color: kOrange),
                          filled: true,
                          fillColor: kOrange.withAlpha(25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// Email
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email, color: kOrange),
                          filled: true,
                          fillColor: kOrange.withAlpha(25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      /// Button with Cubit
                      BlocBuilder<
                        SpeedcashRegisterCubit,
                        SpeedcashRegisterState
                      >(
                        builder: (context, state) {
                          final isLoading = state is SpeedcashRegisterLoading;

                          Future<void> submit() async {
                            final nama = _namaCtrl.text.trim();
                            final phone = _phoneCtrl.text.trim();
                            final email = _emailCtrl.text.trim();

                            if (nama.isEmpty ||
                                phone.isEmpty ||
                                email.isEmpty) {
                              showErrorDialog(
                                context,
                                'Nama, Phone, dan Email tidak boleh kosong',
                              );
                              return;
                            }

                            context
                                .read<SpeedcashRegisterCubit>()
                                .speedcashRegister(
                                  nama: nama,
                                  phone: phone,
                                  email: email,
                                );
                          }

                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : submit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
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
                                      "Register Speedcash",
                                      style: TextStyle(
                                        fontSize: kSize18,
                                        fontWeight: FontWeight.w600,
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
                          Navigator.pushNamed(context, '/speedcashBindingPage');
                        },
                        child: Text(
                          "Sudah punya akun ? Binding di sini.",
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
