import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../utils/error_dialog.dart';
import '../../services/speedcash_api_service.dart';
import '../../viewmodels/speedcash/speedcash_register_viewmodel.dart';
import '../../services/auth_service.dart';
import 'package:logger/logger.dart';

class SpeedcashRegisterPage extends StatelessWidget {
  SpeedcashRegisterPage({super.key});

  final _namaCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Inject ViewModel
    return ChangeNotifierProvider(
      create: (_) => SpeedcashRegisterVM(
        apiService: SpeedcashApiService(
          authService: AuthService(),
          logger: Logger(),
        ),
      ),
      child: Consumer<SpeedcashRegisterVM>(
        builder: (context, vm, _) {
          Future<void> _register() async {
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

            final result = await vm.register(
              nama: nama,
              phone: phone,
              email: email,
            );

            if (result['success']) {
              final data = result['data'];
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Success'),
                  content: Text(
                    'Berhasil daftar.\nRedirect URL: ${data.redirectUrl ?? "-"}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              showErrorDialog(
                context,
                result['message'] ?? 'Terjadi kesalahan',
              );
            }
          }

          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: const Text(
                'Speedcash Register',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.orangeAccent[700],
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 1,
                  color: Colors.white,
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
                              color: Colors.orange,
                            ),
                            filled: true,
                            fillColor: Colors.orange.withOpacity(0.1),
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
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.orange,
                            ),
                            filled: true,
                            fillColor: Colors.orange.withOpacity(0.1),
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
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.orange,
                            ),
                            filled: true,
                            fillColor: Colors.orange.withOpacity(0.1),
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
                            onPressed: vm.isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.orange,
                              elevation: 1,
                            ),
                            child: vm.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Register Speedcash",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
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
                            style: TextStyle(color: Colors.orangeAccent[700]),
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
