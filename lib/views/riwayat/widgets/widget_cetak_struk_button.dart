import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class CetakStrukButton extends StatelessWidget {
  const CetakStrukButton({super.key, required this.status});

  final dynamic status; //bug disini

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24), // Padding sedikit diperluas agar lega
      decoration: BoxDecoration(
        color: kWhite,
        // Membuat efek "Sheet" dengan radius di atas
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: kBlack.withAlpha(15), // Bayangan lebih halus
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              // Menambahkan shadow berwarna (Glow effect) khas fintech
              shadowColor: kOrange.withAlpha(130),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Rounded modern
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/struk',
                arguments: {'transaksi': status},
              );
            },
            icon: const Icon(Icons.print_rounded, color: kWhite, size: 22),
            label: const Text(
              "Cetak Struk",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kWhite,
                letterSpacing: 0.5, // Sedikit spasi agar font terbaca jelas
              ),
            ),
          ),
        ),
      ),
    );
  }
}
