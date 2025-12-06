import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';

class KYCComparisonCard extends StatelessWidget {
  final Color kPrimary;
  final Color kBlack;
  final Color kTextSecondary;
  const KYCComparisonCard(
    this.kPrimary,
    this.kBlack,
    this.kTextSecondary, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: .circular(16),
        boxShadow: [
          BoxShadow(
            color: kBlack.withAlpha(15),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Comparison
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: kNeutral20,
              borderRadius: const .vertical(top: Radius.circular(16)),
              border: Border(bottom: BorderSide(color: kNeutral20)),
            ),
            child: Row(
              children: [
                const Expanded(flex: 3, child: SizedBox()), // Spacer label
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      "UNREG",
                      style: TextStyle(
                        fontWeight: .w600,
                        color: kNeutral70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimary.withAlpha(25),
                      borderRadius: .circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "REG",
                        style: TextStyle(
                          fontWeight: .bold,
                          color: kPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Row 1
          _buildComparisonRow(
            "Saldo Speedcash max",
            "Rp 2 Juta",
            "Rp 20 Juta",
            kBlack,
            kNeutral70,
            true,
          ),
          Divider(height: 1, color: kNeutral30),
          // Content Row 2
          _buildComparisonRow(
            "Transaksi max perbulan",
            "Rp 10 Juta",
            "Rp 40 Juta",
            kBlack,
            kNeutral70,
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(
    String label,
    String valBasic,
    String valPremium,
    Color kBlack,
    Color kTextSecondary,
    bool highlightPremium,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                color: kTextSecondary,
                fontSize: 13,
                fontWeight: .w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                valBasic,
                style: TextStyle(
                  color: kTextSecondary.withAlpha(200),
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                valPremium,
                style: TextStyle(
                  color: kBlack,
                  fontWeight: .w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
