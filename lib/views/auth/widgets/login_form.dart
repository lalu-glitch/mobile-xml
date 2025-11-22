import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/dialog.dart';
import '../../../data/services/auth_service.dart';
import 'custom_textfield.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final nomorCtrl = TextEditingController();
  final kodeAgenCtrl = TextEditingController();
  final authService = AuthService();

  bool isChecked = false;

  void toggleCheckbox(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  bool loading = false;

  /// Kirim request OTP ke server
  Future<void> doOTP() async {
    final kodeAgen = kodeAgenCtrl.text.trim();
    final nomor = nomorCtrl.text.trim();

    if (kodeAgen.isEmpty || nomor.isEmpty) {
      showAppToast(
        context,
        'Nomor dan kode agen tidak boleh kosong',
        ToastType.warning,
      );
      return;
    }

    setState(() => loading = true);

    final result = await authService.sendOtp(kodeAgen, nomor);

    setState(() => loading = false);

    if (!mounted) return;

    if (result["success"]) {
      Navigator.pushNamed(
        context,
        '/kodeOTP',
        arguments: {
          "kode_reseller": kodeAgen,
          "type": result["data"]["type"],
          "expiresAt": result["data"]["expiresAt"],
        },
      );
    } else {
      showErrorDialog(context, result["message"]);
    }
  }

  void navigateToSnKPage() async {
    final result = await Navigator.pushNamed(context, '/S&KPage');

    if (result is bool) {
      setState(() {
        isChecked = result;
      });
      if (result == true) {
        if (mounted) {
          showAppToast(
            context,
            'Syarat dan Ketentuan telah disetujui.',
            ToastType.success,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .end,
      children: [
        CustomTextField(
          controller: kodeAgenCtrl,
          labelText: 'Kode Agen',
          capitalization: TextCapitalization.characters,
          prefixIcon: Icon(Icons.person, color: kOrangeAccent400),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: nomorCtrl,
          labelText: 'Nomer Whatsapp',
          textFormater: [FilteringTextInputFormatter.digitsOnly],
          prefixIcon: Icon(Icons.phone, color: kOrangeAccent400),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          child: Text(
            'Lupa Kode Agen?',
            style: TextStyle(color: kOrange, fontWeight: FontWeight.bold),
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
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'syarat dan ketentuan',
                      style: TextStyle(
                        color: kOrange,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          navigateToSnKPage();
                        },
                    ),
                    TextSpan(text: ' yang berlaku.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: isChecked || loading
              ? doOTP
              : () {
                  showAppToast(
                    context,
                    'Anda harus menyetujui syarat dan ketentuan',
                    ToastType.error,
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: isChecked ? kOrange : kNeutral40,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text('Login', style: TextStyle(color: kWhite, fontSize: 16)),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  @override
  void dispose() {
    nomorCtrl.dispose();
    kodeAgenCtrl.dispose();
    super.dispose();
  }
}
