import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../widgets/widget_ktp_image_guide.dart';
import '../../widgets/kyc_ktp_onboarding/widget_numbered_step.dart';
import '../../widgets/widget_header_step.dart';
import '../../widgets/widget_kyc_action_button.dart';
import '../kamera/ktp_kamera_page.dart';

class FotoKTPOnboardingPage extends StatelessWidget {
  const FotoKTPOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kBlack),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const .symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const KYCHeader(
                    step: "2 dari 4",
                    title: "Foto Kartu Penduduk",
                  ),

                  const SizedBox(height: 32),
                  const KTPImageGuideSection(
                    imageValid: 'assets/images/kyc/ktp_valid.png',
                    imageInvalid: 'assets/images/kyc/ktp_invalid.png',
                  ),
                  const SizedBox(height: 32),

                  const KYCNumberStep(
                    number: "1",
                    text: "Pastikan E-KTP masuk ke dalam bingkai yang tersedia",
                  ),
                  const SizedBox(height: 16),
                  const KYCNumberStep(
                    number: "2",
                    text:
                        "Pastikan E-KTP masih dalam kondisi bagus dan tidak rusak",
                  ),
                  const SizedBox(height: 16),
                  const KYCNumberStep(
                    number: "3",
                    text: "Pastikan kamu memakai E-KTP asli (bukan fotokopi)",
                  ),
                  const SizedBox(height: 100),
                  SafeArea(
                    child: KYCActionButton(
                      title: 'Mulai verifikasi',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KTPCameraPage(),
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
    );
  }
}
