import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../viewmodels/balance_viewmodel.dart';
import 'saldo_action_item.dart';

class HeaderSaldo extends StatefulWidget {
  const HeaderSaldo({required this.balanceVM, super.key});

  final BalanceViewModel balanceVM;

  @override
  State<HeaderSaldo> createState() => _HeaderSaldoState();
}

class _HeaderSaldoState extends State<HeaderSaldo> {
  bool _isSaldoHidden = true;

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
            Image.asset(
              'assets/images/logo_name.png',
              height: 16,
            ), //nanti diganti dari API
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _isSaldoHidden
                  ? 'Rp •••••••'
                  : 'Rp ${widget.balanceVM.userBalance?.saldo ?? 0}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: kBlack,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                setState(() {
                  _isSaldoHidden = !_isSaldoHidden; // Toggle nilai boolean
                });
              },
              child: Icon(
                _isSaldoHidden ? Icons.visibility_off : Icons.visibility,
                color: kBlack,
              ),
            ),
          ],
        ),
        Spacer(),
        // const SizedBox(height: 24),
        IntrinsicHeight(
          child: Row(
            children: [
              ActionItem(Icons.add_rounded, 'Top Up Saldo'),
              const SizedBox(width: 16),
              ActionItem(Icons.swap_horiz_sharp, 'Transfer Saldo'),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
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
