import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xmlapp/views/riwayat_page.dart';
import 'package:animated_check/animated_check.dart';

class TransaksiSuksesPage extends StatefulWidget {
  const TransaksiSuksesPage();

  @override
  State<TransaksiSuksesPage> createState() => _TransaksiSuksesPageState();
}

class _TransaksiSuksesPageState extends State<TransaksiSuksesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(
                      0.9,
                    ), // lingkaran transparan putih
                  ),
                  child: Center(
                    child: AnimatedCheck(
                      progress: _animation,
                      size: 80, // lebih kecil biar ada space di lingkaran
                      color: Colors.green,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "Transaksi Sukses",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Terima kasih telah menjadi mitra terpercaya kami.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RiwayatTransaksiPage()),
                  );
                },
                child: const Text("Buka Riwayat Transaksi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
