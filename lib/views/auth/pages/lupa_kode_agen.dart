import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xmlapp/views/auth/widgets/custom_textfield.dart';

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
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: kWhite,
        body: BlocConsumer<RequestKodeAgenCubit, RequestKodeAgenState>(
          listener: (context, state) async {
            if (state is RequestKodeAgenLoaded) {
              final ok = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => SuccessDialog(
                  message:
                      'Kode agen berhasil dikirim, silahkan cek WhatsApp anda',
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
              return const Center(
                child: CircularProgressIndicator(color: kOrange),
              );
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kOrange.withOpacity(0.1),
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      "Lupa Kode Agen",
                      style: TextStyle(
                        fontSize: kSize28,
                        fontWeight: FontWeight.bold,
                        color: kBlack,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      "Masukkan nomor WhatsApp yang terdaftar, "
                      "kami akan mengirimkan kode agen ke WhatsApp Anda.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: kSize14,
                        color: kNeutral80,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),

                    CustomTextField(
                      controller: _nomorCtrl,
                      labelText: 'Nomer Whatsapp',
                      textFormater: [FilteringTextInputFormatter.digitsOnly],
                      prefixIcon: Icon(Icons.phone, color: kOrangeAccent400),
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 28),

                    // Tombol submit
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
                        ),
                        child: Text(
                          "Kirim Permintaan",
                          style: TextStyle(
                            fontSize: kSize18,
                            fontWeight: FontWeight.bold,
                            color: kWhite,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tombol kembali
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/authPage");
                      },
                      child: Text(
                        "← Kembali ke Request OTP",
                        style: TextStyle(
                          fontSize: kSize14,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
