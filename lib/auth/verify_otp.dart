import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/error_dialog.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _otpCtrl = TextEditingController();
  final _authService = AuthService();

  bool _loading = false;

  Future<void> _doVerify(String username) async {
    if (_otpCtrl.text.trim().isEmpty) {
      showErrorDialog(context, "OTP tidak boleh kosong");
      return;
    }

    setState(() => _loading = true);
    final result = await _authService.verifyOtp(username, _otpCtrl.text.trim());
    setState(() => _loading = false);

    if (result["success"]) {
      // ✅ Jika sukses, pindah ke HomePage
      Navigator.pushReplacementNamed(context, '/');
      ;
    } else {
      showErrorDialog(context, result["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Ambil username dari arguments
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final username = args["username"];
    final nomor = args["nomor"];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified, size: 60, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text(
                    "Verifikasi OTP",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Kode OTP dikirim ke $username",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _otpCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Kode OTP",
                      prefixIcon: const Icon(Icons.sms),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : () => _doVerify(username),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Verifikasi",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
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
}
