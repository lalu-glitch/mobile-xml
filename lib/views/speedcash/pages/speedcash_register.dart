import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../../data/services/speedcash_api_service.dart';
import '../../../viewmodels/speedcash/speedcash_viewmodel.dart';
import '../../../data/services/auth_service.dart';
import 'package:logger/logger.dart';

class SpeedcashRegisterPage extends StatelessWidget {
  SpeedcashRegisterPage({super.key});

  final _namaCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpeedcashVM(
        apiService: SpeedcashApiService(
          authService: AuthService(),
          logger: Logger(),
        ),
      ),
      child: Consumer<SpeedcashVM>(
        builder: (context, vm, _) {
          Future<void> speedcashRegister() async {
            final nama = _namaCtrl.text.trim();
            final phone = _phoneCtrl.text.trim();
            final email = _emailCtrl.text.trim();

            if (nama.isEmpty || phone.isEmpty || email.isEmpty) {
              showErrorDialog(
                context,
                'Nama, Phone, dan Email tidak boleh kosong',
              );
              return;
            }

            await vm.speedcashRegister(nama: nama, phone: phone, email: email);

            // log full result
            Logger().d("Result register: $vm.response");

            if (vm.response != null && vm.response!.redirectUrl != null) {
              Navigator.pushNamed(
                context,
                '/webView',
                arguments: {
                  'url': vm.response!.redirectUrl!,
                  'title': 'Registrasi Speedcash',
                },
              );
            } else if (vm.error != null) {
              showErrorDialog(context, vm.error!);
            }
          }

          return Scaffold(
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
                        // Logo
                        Image.asset(
                          'assets/images/logo-speedcash.png',
                          width: 256,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 24),
                        // Nama
                        TextField(
                          controller: _namaCtrl,
                          decoration: InputDecoration(
                            labelText: "Nama",
                            prefixIcon: const Icon(
                              Icons.person,
                              color: kOrange,
                            ),
                            filled: true,
                            fillColor: kOrange.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Phone
                        TextField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Phone",
                            prefixIcon: const Icon(Icons.phone, color: kOrange),
                            filled: true,
                            fillColor: kOrange.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Email
                        TextField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email, color: kOrange),
                            filled: true,
                            fillColor: kOrange.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: vm.isLoading ? null : speedcashRegister,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: kOrange,
                              elevation: 1,
                            ),
                            child: vm.isLoading
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
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/speedcashBindingPage',
                            );
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
          );
        },
      ),
    );
  }
}
