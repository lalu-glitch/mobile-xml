import 'dart:io';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/error_dialog.dart';

class SendOtpPage extends StatefulWidget {
  const SendOtpPage({super.key});

  @override
  State<SendOtpPage> createState() => _SendOtpPageState();
}

class _SendOtpPageState extends State<SendOtpPage> {
  final _usernameCtrl = TextEditingController();
  final _nomorCtrl = TextEditingController();
  final _authService = AuthService();

  bool _loading = false;

  Future<void> _doOtp() async {
    final username = _usernameCtrl.text.trim();
    final nomor = _nomorCtrl.text.trim();

    if (username.isEmpty || nomor.isEmpty) {
      showErrorDialog(context, "Username dan nomor tidak boleh kosong");
      return;
    }

    setState(() => _loading = true);

    // ✅ kirim username & nomor ke service
    final result = await _authService.sendOtp(username, nomor);

    setState(() => _loading = false);

    if (result["success"]) {
      // ✅ kirim username + nomor ke VerifyOtpPage
      Navigator.pushReplacementNamed(
        context,
        '/verifyOtp',
        arguments: {"username": username, "nomor": nomor},
      );
    } else {
      showErrorDialog(context, result["message"]);
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Keluar Aplikasi?'),
            content: const Text('Apakah kamu yakin ingin keluar?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () => exit(0), // keluar aplikasi
                child: const Text('Ya'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                    const Icon(Icons.lock, size: 60, color: Colors.orange),
                    const SizedBox(height: 16),
                    const Text(
                      "Request OTP",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Username field
                    TextField(
                      controller: _usernameCtrl,
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Nomor field
                    TextField(
                      controller: _nomorCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Nomor WhatsApp",
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _doOtp,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.orange,
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
                                "Request OTP",
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
      ),
    );
  }
}
