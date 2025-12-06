import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/currency.dart';
import '../../../../data/models/layanan/flow_state_model.dart';
import '../../cubit/flow_cubit.dart';

class NavigationButtonNoPrefix extends StatelessWidget {
  const NavigationButtonNoPrefix({
    super.key,
    required this.selectedPrice,
    required this.isLastPage,
    required this.flowState,
    required this.flowCubit,
    required this.onPressed,
  });

  final double selectedPrice;
  final bool isLastPage;
  final VoidCallback onPressed;
  final FlowStateModel flowState;
  final FlowCubit flowCubit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: kOrange,
        padding: const .symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              "Total ${CurrencyUtil.formatCurrency(selectedPrice)}",
              style: TextStyle(
                color: kWhite,
                fontWeight: .bold,
                fontSize: kSize16,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kWhite,
                foregroundColor: kOrange,
                shape: RoundedRectangleBorder(borderRadius: .circular(12)),
              ),
              onPressed: onPressed,
              child: const Text(
                "Selanjutnya",
                style: TextStyle(fontWeight: .bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
