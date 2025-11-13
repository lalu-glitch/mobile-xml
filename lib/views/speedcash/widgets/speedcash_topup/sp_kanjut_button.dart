import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/constant_finals.dart';
import '../../../../core/helper/currency.dart';
import '../../../../core/utils/dialog.dart';
import '../../cubit/request_topup_cubit.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.controller,
    required this.minimumTopUp,
    required this.kodeReseller,
    required this.title,
    super.key,
  });

  final TextEditingController controller;
  final String minimumTopUp;
  final String? kodeReseller;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kOrange,
            foregroundColor: kWhite,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            if (controller.text.isEmpty) {
              return showAppToast(
                context,
                'Nominal tidak boleh kosong',
                ToastType.error,
              );
            }

            final format = controller.text.replaceAll(RegExp(r'[^0-9]'), '');
            final nominal = int.parse(format);

            if (nominal < int.parse(minimumTopUp)) {
              return showAppToast(
                context,
                'Minimal Top up ${CurrencyUtil.formatCurrency(double.tryParse(minimumTopUp))}',
                ToastType.error,
              );
            }

            context.read<RequestTopUpCubit>().requestTopUp(
              kodeReseller!,
              nominal,
              title ?? '',
            );
          },
          child: const Text(
            "Selanjutnya",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
