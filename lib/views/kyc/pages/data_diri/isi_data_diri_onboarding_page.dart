import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../widgets/kyc_data_diri/widget_comparison_card.dart';
import '../../widgets/widget_kyc_action_button.dart';
import '../../widgets/kyc_data_diri/widget_timeline_step.dart';
import '../../widgets/widget_secure_footer.dart';
import 'isi_data_diri_page.dart';

class IsiDataDiriOnboardingPage extends StatefulWidget {
  const IsiDataDiriOnboardingPage({super.key});

  @override
  State<IsiDataDiriOnboardingPage> createState() =>
      _IsiDataDiriOnboardingPageState();
}

class _IsiDataDiriOnboardingPageState extends State<IsiDataDiriOnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        scrolledUnderElevation: 0.0,
        title: const Text(
          "Verifikasi Akun",
          style: TextStyle(color: kBlack, fontWeight: .bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: .stretch,
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
                            fontWeight: .w800,
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
                      crossAxisAlignment: .start,
                      children: [
                        const Text(
                          "Cara Verifikasi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: .bold,
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
                  SecureFooter(),
                  const SizedBox(height: 50),
                  SafeArea(
                    child: KYCActionButton(
                      title: 'Mulai verifikasi',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IsiDataDiriPage(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. FLOATING BOTTOM BUTTON
        ],
      ),
    );
  }
}
