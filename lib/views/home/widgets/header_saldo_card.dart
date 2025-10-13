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
            children: [
              _ActionItem(icon: Icons.add_rounded, label: 'Top Up Saldo'),
              const SizedBox(width: 16),
              _ActionItem(
                icon: Icons.swap_horiz_sharp,
                label: 'Transfer Saldo',
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: kOrange,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_2_outlined, color: kWhite, size: 24),
                        // SizedBox(height: 8),
                        Text(
                          'Tampilkan QRIS',
                          style: TextStyle(color: kWhite, fontSize: 12),
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
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: kNeutral90,
            ),
          ),
        ),
      ],
    );
  }
}
