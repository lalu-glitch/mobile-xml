import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/helper/constant_finals.dart';
import '../../core/utils/bottom_sheet.dart';
import '../../core/utils/error_dialog.dart';
import '../../data/services/auth_service.dart';
import 'widgets/custom_textfield.dart';

class KodeOTP extends StatefulWidget {
  const KodeOTP({super.key});

  @override
  State<KodeOTP> createState() => _KodeOTPState();
}

class _KodeOTPState extends State<KodeOTP> {
  final kodeOTPCtrl = TextEditingController();
  final authService = AuthService();

  //state
  bool loading = false;
  Timer? timer;
  int start = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String expire = args["expiresAt"];

    final expiresAt = DateTime.parse(expire);
    start = expiresAt.difference(DateTime.now()).inSeconds;

    if (start > 0) {
      startTimer();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  // Methode buat format waktu
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  // Methode request verifikasi OTP ke server
  Future<void> doVerifyOTP(String kodeReseller, String type) async {
    if (kodeOTPCtrl.text.trim().isEmpty) {
      showInfoToast("OTP tidak boleh kosong", kRed);
      return;
    }

    setState(() => loading = true);
    final result = await authService.verifyOtp(
      kodeReseller,
      kodeOTPCtrl.text.trim(),
      type,
    );
    setState(() => loading = false);

    if (result["success"]) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      showErrorDialog(context, result["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final kodeAgen = args["kodeAgen"];
    final type = args["type"];
    final kodeReseller = args["kode_reseller"];

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: kBlack),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.headset_mic, color: kOrange),
                    onPressed: () {
                      showCSBottomSheet(context, "Hubungi CS");
                    },
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
                'Masukkan kode OTP yang telah kami kirimkan ke akun whatsapp Anda',
                style: TextStyle(
                  fontSize: 14,
                  color: kNeutral80,
                  fontWeight: FontWeight.normal,
                ),
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
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Text(
                "Kode OTP akan kadaluarsa dalam ${formatTime(start)}",
                style: TextStyle(
                  fontSize: Screen.kSize14,
                  color: start == 0 ? kRed : kNeutral80,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: loading || start == 0
                    ? null
                    : () => doVerifyOTP(
                        type == "register" ? kodeReseller : kodeAgen,
                        type,
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: start == 0 ? kNeutral40 : kOrange,
                  minimumSize: Size(double.infinity, 50),
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
    );
  }

  @override
  void dispose() {
    kodeOTPCtrl.dispose();
    timer?.cancel();
    super.dispose();
  }
}
