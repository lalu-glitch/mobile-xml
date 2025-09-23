import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/helper/constant_finals.dart';
import '../../data/services/auth_service.dart';
import '../../core/utils/error_dialog.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  // Controllers & Services
  final _otpCtrl = TextEditingController();
  final _authService = AuthService();

  //state
  bool _loading = false;
  Timer? _timer;
  int _start = 0;

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

    // Hitung durasi dari sekarang hingga waktu kedaluwarsa
    final expiresAt = DateTime.parse(expire);
    _start = expiresAt.difference(DateTime.now()).inSeconds;

    // Mulai timer hanya jika sisa waktu lebih dari 0
    if (_start > 0) {
      startTimer();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  // Methods
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  /// Kirim request verifikasi OTP ke server
  Future<void> _doVerify(String kodeReseller, String type) async {
    if (_otpCtrl.text.trim().isEmpty) {
      showErrorDialog(context, "OTP tidak boleh kosong");
      return;
    }

    setState(() => _loading = true);
    final result = await _authService.verifyOtp(
      kodeReseller,
      _otpCtrl.text.trim(),
      type,
    );
    setState(() => _loading = false);

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

    final username = args["username"];
    final type = args["type"];
    final kodeReseller = args["kode_reseller"];
    final nomor = args["nomor"];
    final String expire = args["expiresAt"];

    print(expire);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            color: kWhite, // background color
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.verified,
                      size: 64,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Verifikasi OTP",
                    style: TextStyle(
                      fontSize: Screen.kSize24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Kode OTP dikirim ke $nomor",
                    style: TextStyle(
                      fontSize: Screen.kSize14,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    "OTP berlaku ${formatTime(_start)}",
                    style: TextStyle(
                      fontSize: Screen.kSize14,
                      color: _start == 0 ? kRed : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // TextField OTP modern
                  TextField(
                    controller: _otpCtrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: Screen.kSize16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: "Kode OTP",
                      labelStyle: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(Icons.sms, color: Colors.green.shade700),
                      filled: true,
                      fillColor: Colors.green.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.green.shade400,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Tombol Verifikasi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading || _start == 0
                          ? null
                          : () => _doVerify(
                              type == "register" ? kodeReseller : username,
                              type,
                            ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: _start == 0
                            ? Colors.grey
                            : Colors.green,
                        elevation: 1,
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: kWhite,
                              ),
                            )
                          : Text(
                              "Verifikasi",
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
                      Navigator.pushReplacementNamed(context, '/authPage');
                    },
                    child: const Text(
                      "Kirim ulang OTP",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
