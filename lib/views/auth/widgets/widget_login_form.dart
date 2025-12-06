import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../../core/helper/custom_textfield.dart';
import '../cubit/login_cubit.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final nomorCtrl = TextEditingController();
  final kodeResellerCtrl = TextEditingController();

  bool isChecked = false;

  void toggleCheckbox(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  void navigateToSnKPage() async {
    final result = await Navigator.pushNamed(context, '/S&KPage');
    if (result is bool) {
      setState(() => isChecked = result);
      if (result == true && mounted) {
        showAppToast(
          context,
          'Syarat dan Ketentuan telah disetujui.',
          ToastType.success,
        );
      }
    }
  }

  /// VALIDASI + EKSEKUSI LOGIN
  void _onLoginPressed() {
    final kodeAgen = kodeResellerCtrl.text.trim();
    final nomor = nomorCtrl.text.trim();

    if (kodeAgen.isEmpty || nomor.isEmpty) {
      showAppToast(
        context,
        'Nomor dan kode agen tidak boleh kosong',
        ToastType.warning,
      );
      return;
    }

    context.read<LoginCubit>().login(nomor, kodeAgen);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .end,
      children: [
        CustomTextField(
          controller: kodeResellerCtrl,
          labelText: 'Kode Agen',
          capitalization: TextCapitalization.characters,
          prefixIcon: Icon(Icons.person, color: kOrangeAccent400),
        ),
        const SizedBox(height: 16),

        CustomTextField(
          controller: nomorCtrl,
          labelText: 'Nomor Whatsapp',
          textFormater: [FilteringTextInputFormatter.digitsOnly],
          prefixIcon: Icon(Icons.phone, color: kOrangeAccent400),
          keyboardType: TextInputType.phone,
        ),

        const SizedBox(height: 20),
        GestureDetector(
          child: Text(
            'Lupa Kode Agen?',
            style: TextStyle(color: kOrange, fontWeight: .bold),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/lupaKodeAgen');
          },
        ),

        const SizedBox(height: 24),
        Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: toggleCheckbox,
              activeColor: kOrange,
              checkColor: kWhite,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: 'Dengan login, Anda telah setuju dengan ',
                  style: TextStyle(color: kBlack, fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'syarat dan ketentuan',
                      style: TextStyle(
                        color: kOrange,
                        fontWeight: .w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = navigateToSnKPage,
                    ),
                    TextSpan(text: ' yang berlaku.'),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              final kodeReseller = kodeResellerCtrl.text.trim();
              Navigator.pushNamed(
                context,
                '/kodeOTP',
                arguments: {
                  "kode_reseller": kodeReseller,
                  "type": state.data["type"],
                  "expiresAt": state.data["expiresAt"],
                },
              );
            }

            if (state is LoginError) {
              showErrorDialog(context, state.message);
            }
          },
          builder: (context, state) {
            final bool isLoading = state is LoginLoading;

            return ElevatedButton(
              onPressed: (!isChecked || isLoading) ? null : _onLoginPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: kOrange,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: .circular(15)),
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: kWhite),
                    )
                  : const Text(
                      'Masuk',
                      style: TextStyle(color: kWhite, fontSize: 16),
                    ),
            );
          },
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  @override
  void dispose() {
    nomorCtrl.dispose();
    kodeResellerCtrl.dispose();
    super.dispose();
  }
}
