import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

///class buat beri animasi di cek transaksi [gemini]
class FintechPulseLoader extends StatefulWidget {
  final Color color;
  final IconData icon;

  const FintechPulseLoader({
    super.key,
    this.color = kOrange, // Sesuaikan kOrange
    this.icon = Icons.hourglass_top_rounded,
  });

  @override
  State<FintechPulseLoader> createState() => _FintechPulseLoaderState();
}

class _FintechPulseLoaderState extends State<FintechPulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ring 1 (Luas)
          _buildRing(1.0),
          // Ring 2 (Sedang)
          _buildRing(0.75),
          // Ring 3 (Kecil)
          _buildRing(0.5),
          // Icon Tengah
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: widget.color,
              shape: .circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withAlpha(105),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(widget.icon, color: kWhite, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildRing(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = (_controller.value + delay) % 1.0;
        return Container(
          width: 60 + (value * 1400), // Mengembang dari 60 ke 120
          height: 60 + (value * 60),
          decoration: BoxDecoration(
            shape: .circle,
            border: Border.all(
              color: widget.color.withAlpha((255 - value).toInt()), // Fade out
              width: 4 * (1.0 - value), // Menipis
            ),
          ),
        );
      },
    );
  }
}
