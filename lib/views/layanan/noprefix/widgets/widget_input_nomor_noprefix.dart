import 'package:flutter/material.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/currency.dart';
import '../../../../core/helper/dynamic_app_page.dart';
import '../../../../data/models/layanan/flow_state_models.dart';
import '../../cubit/flow_cubit.dart';

class NavigationButtonNoPrefix extends StatelessWidget {
  const NavigationButtonNoPrefix({
    super.key,
    required this.selectedPrice,
    required this.isLastPage,
    required this.flowState,
    required this.flowCubit,
  });

  final double selectedPrice;
  final bool isLastPage;
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
                fontWeight: FontWeight.bold,
                fontSize: kSize16,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kWhite,
                foregroundColor: kOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (!isLastPage) {
                  final nextPage =
                      flowState.sequence[flowState.currentIndex + 1];
                  flowCubit.nextPage();
                  Navigator.pushNamed(context, pageRoutes[nextPage]!);
                } else {
                  Navigator.pushNamed(context, '/konfirmasiPembayaran');
                }
              },
              child: const Text(
                "Selanjutnya",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
