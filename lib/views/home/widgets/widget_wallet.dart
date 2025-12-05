import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../../data/models/user/user_balance_model.dart';
import 'widget_saldo_action_item.dart';

class CardWallet extends StatefulWidget {
  const CardWallet({
    required this.title,
    required this.balance,
    required this.themeColor,
    required this.data,
    super.key,
  });

  final String title;
  final int balance;
  final Color themeColor;
  final UserBalance? data;
  @override
  State<CardWallet> createState() => _CardWalletState();
}

class _CardWalletState extends State<CardWallet> {
  bool _isSaldoHidden = true;

  @override
  Widget build(BuildContext context) {
    log('[KODE LEVEL]: ${widget.data?.kodeLevel}');
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
        if (widget.data?.kodeLevel != 'VERIF1' ||
            widget.data?.kodeLevel != 'VERIF2') ...[
          IntrinsicHeight(
            child: Row(
              children: [
                InkWell(
                  onTap: widget.title == 'Speedcash'
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

                Expanded(
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
      ],
    );
  }
}
