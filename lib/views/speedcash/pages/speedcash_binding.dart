import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/error_dialog.dart';
import '../../../data/services/speedcash_api_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../viewmodels/speedcash/speedcash_viewmodel.dart';

class SpeedcashBindingPage extends StatelessWidget {
  SpeedcashBindingPage({super.key});

  final _phoneCtrl = TextEditingController();
  final _merchantIdCtrl = TextEditingController();

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
          Future<void> bindSpeedcash() async {
            final phone = _phoneCtrl.text.trim();
            final merchantId = _merchantIdCtrl.text.trim();

            if (phone.isEmpty || merchantId.isEmpty) {
              showErrorDialog(
                context,
                'Phone dan Merchant ID tidak boleh kosong',
              );
              return;
            }

            await vm.speedcashBinding(phone: phone, merchantId: merchantId);

            Logger().d("Result binding: ${vm.response}");

            if (vm.response != null && vm.response!.redirectUrl != null) {
              Navigator.pushNamed(
                context,
                '/webView',
                arguments: {
                  'url': vm.response!.redirectUrl!,
                  'title': 'Binding Speedcash',
                },
              );
            } else if (vm.error != null) {
              showErrorDialog(context, vm.error!);
            }
          }

          return PopScope(
            canPop: true,
            child: Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: AppBar(
                title: const Text(
                  'Speedcash Binding',
                  style: TextStyle(color: kWhite, fontWeight: FontWeight.bold),
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

                          // Phone
                          TextField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "Phone",
                              prefixIcon: const Icon(
                                Icons.phone,
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

                          // Merchant ID
                          TextField(
                            controller: _merchantIdCtrl,
                            decoration: InputDecoration(
                              labelText: "Merchant ID",
                              prefixIcon: const Icon(
                                Icons.account_balance,
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
                          const SizedBox(height: 28),

                          // Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: vm.isLoading ? null : bindSpeedcash,
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
                                      "Bind Speedcash",
                                      style: TextStyle(
                                        fontSize: Screen.kSize18,
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
                                '/speedcashRegisterPage',
                              );
                            },
                            child: Text(
                              "Belum punya akun ? Buat di sini.",
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
          );
        },
      ),
    );
  }
}
