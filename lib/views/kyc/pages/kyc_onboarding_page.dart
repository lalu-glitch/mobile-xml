import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../widgets/widget_comparison_card.dart';
import '../widgets/widget_kyc_fab.dart';
import '../widgets/widget_timeline_step.dart';

class KYCOnboardingPage extends StatelessWidget {
  const KYCOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        title: const Text(
          "Verifikasi Akun",
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. HERO SECTION & VALUE PROP
                  Container(
                    color: kWhite,
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        // Illustration Placeholder (Modern Bubble Style)
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: kOrange.withAlpha(25),
                            shape: .circle,
                          ),
                          child: const Icon(
                            Icons.verified_user_rounded,
                            color: kOrange,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Buka Batas Transaksimu!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: kBlack,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Verifikasi datamu untuk menikmati limit saldo\ndan transaksi yang jauh lebih besar.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: kNeutral80,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // COMPARISON CARD (Replacing the Grid Table)
                        KYCComparisonCard(kOrange, kBlack, kNeutral80),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. STEPS (TIMELINE STYLE)
                  Container(
                    color: kWhite,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Cara Verifikasi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kBlack,
                          ),
                        ),
                        const SizedBox(height: 24),
                        KYCTimelineStep(
                          icon: Icons.description_outlined,
                          title: "Isi data diri",
                          subtitle: "Pastikan data diri sesuai",
                          isFirst: true,
                          kPrimary: kOrange,
                        ),
                        KYCTimelineStep(
                          icon: Icons.badge_outlined,
                          title: "Siapkan e-KTP",
                          subtitle: "Pastikan tulisan pada KTP terbaca jelas",
                          isFirst: true,
                          kPrimary: kOrange,
                        ),
                        KYCTimelineStep(
                          icon: Icons.camera_alt_outlined,
                          title: "Foto Selfie + KTP",
                          subtitle: "Wajah tidak tertutup masker/kacamata",
                          kPrimary: kOrange,
                        ),
                        KYCTimelineStep(
                          icon: Icons.check_circle_outline,
                          title: "Kirim & Tunggu Verifikasi",
                          subtitle: "Proses maksimal 1x24 jam kerja",
                          isLast: true,
                          kPrimary: kOrange,
                        ),
                      ],
                    ),
                  ),

                  // 3. TRUST FOOTER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 16,
                          color: kNeutral80,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Data terenkripsi & diawasi oleh",
                          style: TextStyle(
                            color: kNeutral80,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 35,
                    color: kWhite,
                    child: Image.asset('assets/images/kyc/bi-logo.png'),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // 4. FLOATING BOTTOM BUTTON
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: KYCFloatingActionButton(
        title: 'Mulai verifikasi',
        onPressed: () => print('cok'),
      ),
    );
  }
}
