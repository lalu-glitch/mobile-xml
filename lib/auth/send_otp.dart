// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/auth_service.dart';
import '../utils/cs_bottom_sheet.dart';
import '../utils/error_dialog.dart';

class SendOtpPage extends StatefulWidget {
  const SendOtpPage({super.key});

  @override
  State<SendOtpPage> createState() => _SendOtpPageState();
}

class _SendOtpPageState extends State<SendOtpPage> {
  // Controllers & Services
  final _usernameCtrl = TextEditingController();
  final _nomorCtrl = TextEditingController();
  final _authService = AuthService();

  // State
  bool _loading = false;

  // Methods
  /// Kirim request OTP ke server
  Future<void> _doOtp() async {
    final username = _usernameCtrl.text.trim();
    final nomor = _nomorCtrl.text.trim();

    if (username.isEmpty || nomor.isEmpty) {
      showErrorDialog(context, "Username dan nomor tidak boleh kosong");
      return;
    }

    setState(() => _loading = true);

    final result = await _authService.sendOtp(username, nomor);

    setState(() => _loading = false);

    if (result["success"]) {
      Navigator.pushReplacementNamed(
        context,
        '/verifyOtp',
        arguments: {"username": username, "nomor": nomor},
      );
    } else {
      showErrorDialog(context, result["message"]);
    }
  }

  /// Konfirmasi sebelum keluar aplikasi
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
              TextButton(onPressed: () => exit(0), child: const Text('Ya')),
            ],
          ),
        ) ??
        false;
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 1,
                  color: Colors.white,
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
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange.withOpacity(0.2),
                          ),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 256,
                            height: 256,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Title
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Username
                        TextField(
                          controller: _usernameCtrl,
                          decoration: InputDecoration(
                            labelText: "Kode Agen",
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.orange,
                            ),
                            filled: true,
                            fillColor: Colors.orange.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Nomor WhatsApp
                        TextField(
                          controller: _nomorCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Nomor WhatsApp",
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.orange,
                            ),
                            filled: true,
                            fillColor: Colors.orange.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Tombol request OTP
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _doOtp,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.orange,
                              elevation: 1,
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Request OTP",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Extra actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.lock_reset,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Lupa Kode Agen",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/lupaKodeAgen',
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.headset_mic,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Hubungi CS",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () =>
                                  showCSBottomSheet(context, "Hubungi CS"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                //SOON
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/registerpage");
                  },
                  child: Text(
                    'Belum punya akun? Daftar sekarang!',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
