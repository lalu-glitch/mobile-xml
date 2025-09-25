import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../cubit/request_kode_agen_cubit.dart';

class LupaKodeAgenPage extends StatefulWidget {
  const LupaKodeAgenPage({super.key});

  @override
  State<LupaKodeAgenPage> createState() => _LupaKodeAgenPageState();
}

class _LupaKodeAgenPageState extends State<LupaKodeAgenPage> {
  final _nomorCtrl = TextEditingController();

  Future<void> _doRequestKodeAgen() async {
    final nomor = _nomorCtrl.text.trim();

    if (nomor.isEmpty) {
      showErrorDialog(context, "Nomor WhatsApp tidak boleh kosong");
      return;
    }

    context.read<RequestKodeAgenCubit>().requestKodeAgen(nomor);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await showExitDialog(context);
        if (shouldExit) {
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: BlocConsumer<RequestKodeAgenCubit, RequestKodeAgenState>(
          listener: (context, state) async {
            if (state is RequestKodeAgenLoaded) {
              // tampilkan dialog sukses
              final ok = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => SuccessDialog(
                  message:
                      'Kode agen berhasil dikirim, silahkan cek Whatsapp anda',
                  onOk: () {
                    Navigator.pushReplacementNamed(context, '/authPage');
                  },
                ),
              );

              if (ok == true) {
                Navigator.pushReplacementNamed(context, "/authPage");
              }
            } else if (state is RequestKodeAgenError) {
              showErrorDialog(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is RequestKodeAgenLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
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
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kOrange.withOpacity(0.2),
                          ),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 180,
                            height: 180,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Lupa Kode Agen",
                          style: TextStyle(
                            fontSize: Screen.kSize24,
                            fontWeight: FontWeight.bold,
                            color: kOrange,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Input nomor
                        TextField(
                          controller: _nomorCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Nomor WhatsApp",
                            prefixIcon: const Icon(Icons.phone, color: kOrange),
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
                            onPressed: _doRequestKodeAgen,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: kOrange,
                              elevation: 1,
                            ),
                            child: Text(
                              "Kirim Permintaan",
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
                            Navigator.pushReplacementNamed(
                              context,
                              "/authPage",
                            );
                          },
                          child: Text(
                            "Kembali ke Request OTP",
                            style: TextStyle(
                              fontSize: Screen.kSize14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
