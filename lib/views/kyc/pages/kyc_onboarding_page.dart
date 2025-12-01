import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class KYCOnboardingPage extends StatelessWidget {
  const KYCOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: kSize24,
                  vertical: kSize24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Illustration Placeholder
                        Container(
                          width: kSize56,
                          height: kSize56,
                          decoration: BoxDecoration(
                            color: kBackground,
                            borderRadius: BorderRadius.circular(kSize12),
                          ),
                          child: Icon(
                            Icons.shield_outlined,
                            color: kNeutral100,
                            size: kSize28,
                          ),
                        ),
                        SizedBox(width: kSize16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Upgrade Akunmu, Yuk!",
                                style: TextStyle(
                                  fontSize: kSize18,
                                  fontWeight: FontWeight.bold,
                                  color: kBlack,
                                ),
                              ),
                              SizedBox(height: kSize4),
                              Text(
                                "Nikmati fitur lengkap XML Mobile dengan verifikasi datamu sekarang.",
                                style: TextStyle(
                                  fontSize: kSize14,
                                  color: kNeutral90,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: kSize24),

                    // 2. Comparison Table
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kNeutral40),
                        borderRadius: BorderRadius.circular(kSize12),
                      ),
                      child: Column(
                        children: [
                          // Header Row
                          Padding(
                            padding: EdgeInsets.all(kSize12),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: SizedBox()),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: kSize8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kOrange,
                                      borderRadius: BorderRadius.circular(
                                        kSize8,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "REG",
                                        style: TextStyle(
                                          color: kWhite,
                                          fontWeight: FontWeight.bold,
                                          fontSize: kSize12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: kSize8),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: kSize8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kNeutral50,
                                      borderRadius: BorderRadius.circular(
                                        kSize8,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "UNREG",
                                        style: TextStyle(
                                          color: kNeutral80,
                                          fontWeight: FontWeight.bold,
                                          fontSize: kSize12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: kNeutral40),
                          // Row 1
                          Padding(
                            padding: EdgeInsets.all(kSize12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Maksimal saldo Speedcash",
                                    style: TextStyle(
                                      fontSize: kSize12,
                                      color: kNeutral80,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Rp 20.000.000,-",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(
                                          fontSize: kSize12,
                                          color: kNeutral80,
                                        ).copyWith(
                                          color: kBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Rp 2.000.000,-",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: kSize12,
                                      color: kNeutral80,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: kNeutral40),
                          // Row 2
                          Container(
                            padding: EdgeInsets.all(kSize12),
                            decoration: BoxDecoration(
                              color: kBackground.withOpacity(
                                0.3,
                              ), // Slight shading if needed
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(kSize12),
                                bottomRight: Radius.circular(kSize12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Maksimal transaksi perbulan",
                                    style: TextStyle(
                                      fontSize: kSize12,
                                      color: kNeutral80,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Rp 40.000.000,-",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(
                                          fontSize: kSize12,
                                          color: kNeutral80,
                                        ).copyWith(
                                          color: kBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Rp 10.000.000,-",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: kSize12,
                                      color: kNeutral80,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: kSize24),

                    // 3. 4 Langkah Mudah Text
                    Text(
                      "4 Langkah Mudah Verifikasi Akun",
                      style: TextStyle(
                        fontSize: kSize18,
                        fontWeight: FontWeight.bold,
                        color: kBlack,
                      ).copyWith(fontSize: kSize16),
                    ),
                    SizedBox(height: kSize16),

                    // 4. Step Items
                    _buildStepItem(
                      icon: Icons.list_alt_rounded,
                      text: "Isi data diri lengkap sesuai dokumen",
                      kSize44: kSize44,
                      kSize12: kSize12,
                      kSize14: kSize14,
                      kSize8: kSize8,
                      kOrange: kOrange,
                      kNeutral30: kNeutral30,
                      kBlack: kBlack,
                    ),
                    SizedBox(height: kSize12),
                    _buildStepItem(
                      icon: Icons.file_upload_outlined,
                      text: "Upload dokumen verifikasi (KTP)",
                      kSize44: kSize44,
                      kSize12: kSize12,
                      kSize14: kSize14,
                      kSize8: kSize8,
                      kOrange: kOrange,
                      kNeutral30: kNeutral30,
                      kBlack: kBlack,
                    ),
                    SizedBox(height: kSize12),
                    _buildStepItem(
                      icon: Icons.person_outline, // Placeholder for Selfie Icon
                      text: "Upload foto selfie sambil memegang KTP",
                      kSize44: kSize44,
                      kSize12: kSize12,
                      kSize14: kSize14,
                      kSize8: kSize8,
                      kOrange: kOrange,
                      kNeutral30: kNeutral30,
                      kBlack: kBlack,
                    ),
                    SizedBox(height: kSize12),
                    _buildStepItem(
                      icon: Icons.check,
                      text: "Akunmu siap dipakai!",
                      kSize44: kSize44,
                      kSize12: kSize12,
                      kSize14: kSize14,
                      kSize8: kSize8,
                      kOrange: kOrange,
                      kNeutral30: kNeutral30,
                      kBlack: kBlack,
                    ),

                    SizedBox(height: kSize28),

                    // 5. Disclaimer Footer
                    Container(
                      padding: EdgeInsets.all(kSize16),
                      decoration: BoxDecoration(
                        color: kNeutral30,
                        borderRadius: BorderRadius.circular(kSize12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.security,
                                color: kNeutral90,
                                size: kSize24,
                              ),
                              SizedBox(width: kSize12),
                              Expanded(
                                child: Text(
                                  "Datamu akan dirahasiakan dan hanya digunakan untuk keperluan verifikasi",
                                  style: TextStyle(
                                    fontSize: kSize12,
                                    color: kNeutral80,
                                  ).copyWith(color: kNeutral90),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: kSize12),
                          Row(
                            children: [
                              SizedBox(
                                width: kSize24 + kSize12,
                              ), // Indent to align with text above
                              Text(
                                "Proses ini diawasi oleh",
                                style: TextStyle(
                                  fontSize: kSize12,
                                  color: kNeutral80,
                                ),
                              ),
                              SizedBox(width: kSize8),

                              // BI Logo Placeholder using Text/Icon
                              ///TODO
                              Text(
                                "BANK INDONESIA",
                                style: TextStyle(
                                  color: kBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: kSize10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: kSize48), // Bottom spacing for scroll
                  ],
                ),
              ),
            ),

            // 6. Bottom Button
            SafeArea(
              child: Container(
                color: Colors.transparent,
                padding: .all(16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    padding: EdgeInsets.symmetric(vertical: kSize16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kSize16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Mulai Sekarang",
                    style: TextStyle(
                      color: kWhite,
                      fontSize: kSize16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Steps
  Widget _buildStepItem({
    required IconData icon,
    required String text,
    required double kSize44,
    required double kSize12,
    required double kSize14,
    required double kSize8,
    required Color kOrange,
    required Color kNeutral30,
    required Color kBlack,
  }) {
    return Container(
      padding: EdgeInsets.all(kSize12),
      decoration: BoxDecoration(
        color: kNeutral30, // Light grey background like in design
        borderRadius: BorderRadius.circular(kSize14),
      ),
      child: Row(
        children: [
          Container(
            padding: .all(8),
            decoration: BoxDecoration(
              color: kOrange,
              borderRadius: BorderRadius.circular(kSize8),
            ),
            child: Icon(icon, color: kWhite, size: kSize24),
          ),
          SizedBox(width: kSize12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: kBlack,
                fontWeight: FontWeight.w600,
                fontSize: kSize14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
