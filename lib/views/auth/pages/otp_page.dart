import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/utils/bottom_sheet.dart';
import '../../../core/utils/dialog.dart';
import '../../../data/services/auth_service.dart';
import '../widgets/custom_textfield.dart';

class KodeOTP extends StatefulWidget {
  const KodeOTP({super.key});

  @override
  State<KodeOTP> createState() => _KodeOTPState();
}

class _KodeOTPState extends State<KodeOTP> {
  final kodeOTPCtrl = TextEditingController();
  final authService = AuthService();

  bool loading = false;
  Timer? timer;
  int start = 0;
  DateTime? expiresAt;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String expire = args["expiresAt"];
    expiresAt = DateTime.parse(expire);

    start = expiresAt!.difference(DateTime.now()).inSeconds;
    if (start > 0) {
      startTimer();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted) return;

      final remaining = expiresAt!.difference(DateTime.now()).inSeconds;

      setState(() {
        start = remaining > 0 ? remaining : 0;
      });
      if (remaining <= 0) {
        t.cancel();
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> doVerifyOTP(String kodeReseller, String type) async {
    if (kodeOTPCtrl.text.trim().isEmpty) {
      showAppToast(context, 'OTP tidak boleh kosong', ToastType.warning);
      return;
    }

    setState(() => loading = true);
    final result = await authService.verifyOtp(
      kodeReseller,
      kodeOTPCtrl.text.trim(),
      type,
    );
    if (!mounted) return;
    setState(() => loading = false);

    if (result["success"]) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      await showErrorDialog(context, result["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final kodeResellerRegister = args["kode_reseller_register"];
    final type = args["type"];
    final kodeReseller = args["kode_reseller"];

    return Scaffold(
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: kBlack),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.headset_mic_rounded, color: kOrange),
                      onPressed: () => showCSBottomSheet(
                        context,
                        "Hubungi Customer Service",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  'Verifikasi Kode OTP',
                  style: TextStyle(
                    fontSize: 24,
                    color: kNeutral100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Masukkan kode OTP yang telah kami kirimkan ke akun WhatsApp Anda',
                  style: TextStyle(fontSize: 14, color: kNeutral80),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  controller: kodeOTPCtrl,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                    letterSpacing: 30,
                  ),
                  align: TextAlign.center,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                Text(
                  "Kode OTP akan kadaluarsa dalam ${formatTime(start)}",
                  style: TextStyle(
                    fontSize: kSize14,
                    color: start == 0 ? kRed : kNeutral80,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: loading || start == 0
                      ? null
                      : () => doVerifyOTP(
                          type == "register"
                              ? kodeResellerRegister
                              : kodeReseller,
                          type ?? '',
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: start == 0 ? kNeutral40 : kOrange,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Verifikasi',
                    style: TextStyle(color: kWhite, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Tidak mendapat kode OTP?',
                  style: TextStyle(color: kNeutral100, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/authPage'),
                  child: Text(
                    'Kirim ulang kode OTP',
                    style: TextStyle(
                      color: kOrangeAccent500,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                      decorationColor: kOrangeAccent300,
                      decorationThickness: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    kodeOTPCtrl.dispose();
    timer?.cancel();
    super.dispose();
  }
}
