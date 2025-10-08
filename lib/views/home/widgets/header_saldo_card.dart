import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class HeaderSaldo extends StatelessWidget {
  const HeaderSaldo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Saldo XML',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: kBlack,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 8),
            Image.asset('assets/images/logo_name.png', height: 16),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rp 999.999.999',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: kBlack,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.remove_red_eye_outlined,
                color: kBlack,
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ActionItem(icon: Icons.add_rounded, label: 'Top Up Saldo'),
              const SizedBox(width: 24),
              _ActionItem(icon: Icons.swap_horiz_sharp, label: 'Transfer Stok'),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: kOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.qr_code_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'QRIS Member',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: kOrange,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: kNeutral90,
          ),
        ),
      ],
    );
  }
}
