// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/services/auth_service.dart';
import '../../core/utils/error_dialog.dart';

class LupaKodeAgenPage extends StatefulWidget {
  const LupaKodeAgenPage({super.key});

  @override
  State<LupaKodeAgenPage> createState() => _LupaKodeAgenPageState();
}

class _LupaKodeAgenPageState extends State<LupaKodeAgenPage> {
  final _nomorCtrl = TextEditingController();
  final _authService = AuthService();

  bool _loading = false;

  Future<void> _doRequestKodeAgen() async {
    final nomor = _nomorCtrl.text.trim();

    if (nomor.isEmpty) {
      showErrorDialog(context, "Nomor WhatsApp tidak boleh kosong");
      return;
    }

    setState(() => _loading = true);

    // 🔥 panggil API (ganti sesuai implementasi Anda di AuthService)
    final result = await _authService.requestKodeAgen(nomor);

    setState(() => _loading = false);

    if (result["success"]) {
      // Tampilkan dialog konfirmasi
      final ok = await showDialog<bool>(
        context: context,
        barrierDismissible: false, // user harus tekan tombol
        builder: (context) => AlertDialog(
          title: const Text("Berhasil"),
          content: Text(result["message"] ?? "Kode agen sudah dikirim"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("OK"),
            ),
          ],
        ),
      );

      // Kalau user tekan OK, pindah page
      if (ok == true) {
        Navigator.pushReplacementNamed(context, "/sendOtp");
      }
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
              TextButton(onPressed: () => exit(0), child: const Text('Ya')),
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
        backgroundColor: Colors.grey[100],
        body: Center(
          child: SingleChildScrollView(
            child: Card(
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
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange.withOpacity(0.2),
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
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 24),

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

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _doRequestKodeAgen,
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
                                "Kirim Permintaan",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/sendOtp");
                      },
                      child: Text(
                        "Kembali ke Request OTP",
                        style: TextStyle(fontSize: 14.sp, color: Colors.blue),
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
