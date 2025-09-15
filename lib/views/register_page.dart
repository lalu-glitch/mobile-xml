import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/helper/constant_finals.dart';
import '../data/services/auth_service.dart';
import '../core/utils/error_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //services
  final _authService = AuthService();
  // State
  bool _loading = false;

  String getTrimmed(TextEditingController ctrl) => ctrl.text.trim();

  final _namaUsahaCtrl = TextEditingController();
  final _namaPemilikCtrl = TextEditingController();
  final _noWACtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();
  final _provinsiCtrl = TextEditingController();
  final _kabupatenCtrl = TextEditingController();
  final _kecamatanCtrl = TextEditingController();
  final _kodeReferralCtrl = TextEditingController();

  void doRegister() async {
    final namaUsaha = getTrimmed(_namaUsahaCtrl);
    final namaPemilik = getTrimmed(_namaPemilikCtrl);
    final noWA = getTrimmed(_noWACtrl);
    final alamat = getTrimmed(_alamatCtrl);
    final provinsi = getTrimmed(_provinsiCtrl);
    final kabupaten = getTrimmed(_kabupatenCtrl);
    final kecamatan = getTrimmed(_kecamatanCtrl);
    final kodeReferral = getTrimmed(_kodeReferralCtrl);

    if (namaUsaha.isEmpty ||
        namaPemilik.isEmpty ||
        noWA.isEmpty ||
        alamat.isEmpty ||
        provinsi.isEmpty ||
        kabupaten.isEmpty ||
        kecamatan.isEmpty) {
      showErrorDialog(context, "Semua field wajib diisi kecuali kode referral");
      return;
    }

    setState(() => _loading = true);

    try {
      final result = await _authService.onRegisterUser(
        namaUsaha,
        namaPemilik,
        noWA,
        alamat,
        provinsi,
        kabupaten,
        kecamatan,
        kodeReferral.isEmpty ? 'DAFTAR' : kodeReferral,
      );

      if (!mounted) return;
      if (result["success"]) {
        print("RESULT REGISTER : $result");
        Navigator.pushReplacementNamed(
          context,
          '/verifyOtp',
          arguments: {
            "kode_reseller": result["data"]["data"]["kode_reseller"],
            "type": result["data"]["data"]["type"],
            "nomor": result["data"]["data"]["nomor"],
          },
        );
      } else {
        showErrorDialog(context, result["message"] ?? "Terjadi kesalahan");
      }
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, "Terjadi kesalahan register: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: 1,
                color: kWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 60,
                  horizontal: 20,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange.withAlpha(25),
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
                        "Daftar",
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      //api/register
                      const SizedBox(height: 24),
                      TextField(
                        controller: _namaUsahaCtrl,
                        decoration: InputDecoration(
                          labelText: "Nama Usaha",
                          prefixIcon: const Icon(
                            Icons.store,
                            color: Colors.orange,
                          ),
                          filled: true,
                          fillColor: Colors.orange.withAlpha(25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: _namaPemilikCtrl,
                        decoration: InputDecoration(
                          labelText: "Nama Pemilik",
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.orange,
                          ),
                          filled: true,
                          fillColor: Colors.orange.withAlpha(25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _noWACtrl,
                        decoration: InputDecoration(
                          labelText: "Nomer Whatsapp",
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.orange,
                          ),
                          filled: true,
                          fillColor: Colors.orange.withAlpha(25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _alamatCtrl,
                        decoration: InputDecoration(
                          labelText: "Alamat",
                          prefixIcon: const Icon(
                            Icons.pin_drop,
                            color: Colors.orange,
                          ),
                          filled: true,
                          fillColor: Colors.orange.withAlpha(25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _provinsiCtrl,
                        decoration: InputDecoration(
                          labelText: "Provinsi",
                          filled: true,
                          fillColor: Colors.orange.withAlpha(25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _kabupatenCtrl,
                        decoration: InputDecoration(
                          labelText: "Kabupaten",
                          filled: true,
                          fillColor: Colors.orange.withAlpha(25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _kecamatanCtrl,
                        decoration: InputDecoration(
                          labelText: "Kecamatan",
                          filled: true,
                          fillColor: Colors.orange.withAlpha(25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _kodeReferralCtrl,
                        decoration: InputDecoration(
                          labelText: "Kode Referral (Optional)",
                          prefixIcon: const Icon(
                            Icons.code,
                            color: Colors.orange,
                          ),
                          filled: true,
                          fillColor: Colors.orange.withAlpha(25),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : doRegister,
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
                                    color: kWhite,
                                  ),
                                )
                              : Text(
                                  "Daftar",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: kWhite,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
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
    _namaUsahaCtrl.dispose();
    _namaPemilikCtrl.dispose();
    _noWACtrl.dispose();
    _alamatCtrl.dispose();
    _provinsiCtrl.dispose();
    _kabupatenCtrl.dispose();
    _kecamatanCtrl.dispose();
    _kodeReferralCtrl.dispose();
    super.dispose();
  }
}
