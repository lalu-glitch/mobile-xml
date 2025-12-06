import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';

class KonfirmasiKYCPage extends StatelessWidget {
  const KonfirmasiKYCPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      // Menggunakan SafeArea agar tidak tertutup notch/status bar
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            // MainAxisAlignment tidak perlu center karena kita pakai Spacer
            crossAxisAlignment: .center,
            children: [
              // Spacer pertama mendorong konten ke tengah vertikal
              const Spacer(),

              // --- Bagian Icon ---
              // Catatan: Di production, ganti Icon ini dengan Image.asset atau SvgPicture
              // Contoh: Image.asset('assets/ic_success.png', width: 80)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(shape: .circle),
                child: const Icon(
                  Icons.verified_outlined, // Placeholder icon
                  size: 100,
                  color: kGreen, // Warna hijau disesuaikan
                ),
              ),

              const SizedBox(height: 24),

              // --- Judul ---
              const Text(
                'PENGAJUAN BERHASIL',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: .bold,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // --- Deskripsi ---
              const Text(
                'Permintaan verifikasi akunmu sudah kami terima.\nSilakan menunggu, pemberitahuan selanjutnya akan\ndikirim setelah proses selesai.',
                style: TextStyle(
                  fontSize: 14,
                  color: kNeutral60, // Gunakan warna abu-abu yang pas
                  height: 1.5, // Line height agar mudah dibaca
                ),
                textAlign: TextAlign.center,
              ),

              // Spacer kedua mendorong tombol ke bawah
              const Spacer(),

              // --- Tombol "Butuh bantuan?" ---
              TextButton(
                onPressed: () {
                  // Aksi bantuan
                },
                style: TextButton.styleFrom(foregroundColor: kNeutral60),
                child: const Text(
                  'Butuh bantuan?',
                  style: TextStyle(fontSize: 14, fontWeight: .w500),
                ),
              ),

              const SizedBox(height: 16),

              // --- Tombol Utama (Full Width) ---
              SizedBox(
                width: double.infinity, // Agar tombol memenuhi lebar layar
                height: 50, // Tinggi standar tombol mobile (44-50px)
                child: ElevatedButton(
                  onPressed: () {
                    // Navigasi kembali ke beranda
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange, // Warna oranye (Dark Orange)
                    foregroundColor: kWhite, // Warna teks putih
                    elevation: 0, // Flat design sesuai gambar
                    shape: RoundedRectangleBorder(
                      borderRadius: .circular(16), // Radius sudut tombol
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(fontSize: 16, fontWeight: .w600),
                  ),
                ),
              ),

              // Memberikan jarak sedikit dari bawah layar
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
