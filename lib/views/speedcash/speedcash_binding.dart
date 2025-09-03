import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/error_dialog.dart';

class SpeedcashBindingPage extends StatefulWidget {
  const SpeedcashBindingPage({super.key});

  @override
  State<SpeedcashBindingPage> createState() => _SpeedcashBindingPageState();
}

class _SpeedcashBindingPageState extends State<SpeedcashBindingPage> {
  final _phoneCtrl = TextEditingController();
  final _merchantIdCtrl = TextEditingController();

  bool _loading = false;

  Future<void> _bindSpeedcash() async {
    final phone = _phoneCtrl.text.trim();
    final merchantId = _merchantIdCtrl.text.trim();

    if (phone.isEmpty || merchantId.isEmpty) {
      // Tampilkan error sederhana
      showErrorDialog(context, 'Phone dan Merchant ID tidak boleh kosong');
      return;
    }

    setState(() => _loading = true);

    // Simulasi API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _loading = false);

    // Tampilkan success
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(
          'Phone: $phone\nMerchant ID: $merchantId berhasil di-bind',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Speedcash Binding',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
                  // Judul
                  Container(
                    child: Image.asset(
                      'assets/images/logo-speedcash.png',
                      width: 256,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Phone
                  TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone",
                      prefixIcon: const Icon(Icons.phone, color: Colors.orange),
                      filled: true,
                      fillColor: Colors.orange.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Merchant ID
                  TextField(
                    controller: _merchantIdCtrl,
                    decoration: InputDecoration(
                      labelText: "Merchant ID",
                      prefixIcon: const Icon(
                        Icons.account_balance,
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
                      onPressed: _loading ? null : _bindSpeedcash,
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
                              "Bind Speedcash",
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
                      Navigator.pushNamed(context, '/speedcashRegisterPage');
                    },
                    child: Text(
                      "Belum punya akun ? Buat di sini.",
                      style: TextStyle(color: Colors.orangeAccent[700]),
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
