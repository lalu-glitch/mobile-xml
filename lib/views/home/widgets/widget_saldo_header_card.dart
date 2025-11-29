import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import 'widget_saldo_action_item.dart';

class HeaderSaldo extends StatefulWidget {
  const HeaderSaldo({
    required this.title,
    required this.balance,
    this.themeColor = kOrange,
    super.key,
  });

  final String title;
  final int balance;
  final Color themeColor;

  @override
  State<HeaderSaldo> createState() => _HeaderSaldoState();
}

class _HeaderSaldoState extends State<HeaderSaldo> {
  bool _isSaldoHidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: kBlack,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/logo_with_name.png',
              height: 16,
            ), //nanti diganti dari API
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              _isSaldoHidden
                  ? 'Rp •••••••'
                  : CurrencyUtil.formatCurrency(widget.balance),
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
                  _isSaldoHidden = !_isSaldoHidden;
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
        IntrinsicHeight(
          child: Row(
            children: [
              InkWell(
                onTap: widget.title == 'SPEEDCASH'
                    ? () {
                        Navigator.pushNamed(context, '/speedcashTopUpPage');
                      }
                    : null,
                child: ActionItem(
                  icon: Icons.add_rounded,
                  label: 'Top Up Saldo',
                  color: widget.themeColor,
                ),
              ),
              const SizedBox(width: 16),
              ActionItem(
                icon: Icons.swap_horiz_sharp,
                label: 'Transfer Saldo',
                color: widget.themeColor,
              ),
              const SizedBox(width: 16),
              widget.title == 'SPEEDCASH'
                  ? SizedBox()
                  : Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.themeColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Column(
                            mainAxisAlignment: .center,
                            children: [
                              Icon(
                                Icons.qr_code_2_outlined,
                                color: kWhite,
                                size: 24,
                              ),

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
