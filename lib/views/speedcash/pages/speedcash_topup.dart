import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../../../core/helper/currency.dart';
import '../../../core/utils/dialog.dart';
import '../../settings/cubit/info_akun/info_akun_cubit.dart';
import '../cubit/panduan_topup_cubit.dart';
import '../cubit/request_topup_cubit.dart';
import '../widgets/speedcash_topup/widget_sp_bank_section.dart';
import '../widgets/speedcash_topup/widget_sp_bank_transfer_dialog.dart';
import '../widgets/speedcash_topup/widget_sp_kanjut_button.dart';
import '../widgets/speedcash_topup/widget_sp_panduan.dart';
import '../widgets/speedcash_topup/widget_sp_topup_header_section.dart';
import '../widgets/speedcash_topup/widget_sp_va_section.dart';

class SpeedcashTopUp extends StatefulWidget {
  const SpeedcashTopUp({
    this.isBank = false,
    this.kodeVA = '',
    this.atasNama = '',
    required this.imageUrl,
    required this.title,
    required this.minimumTopUp,
    super.key,
  });

  final String? title;
  final String? imageUrl;
  final String minimumTopUp;
  final String kodeVA;
  final String atasNama;
  final bool isBank;

  @override
  State<SpeedcashTopUp> createState() => _SpeedcashTopUpState();
}

class _SpeedcashTopUpState extends State<SpeedcashTopUp> {
  late final TextEditingController controller;
  String? kodeReseller;

  @override
  void initState() {
    super.initState();
    final infoState = context.read<InfoAkunCubit>().state;
    if (infoState is InfoAkunLoaded) {
      kodeReseller = infoState.data.data.kodeReseller;
      context.read<PanduanTopUpCubit>().fetchPanduan(
        kodeReseller ?? '',
        widget.title ?? '',
      );
    }
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RequestTopUpCubit, RequestTopUpState>(
        listener: (context, state) {
          log('[state] : $state', name: "reqtopupcubit");
          if (state is RequestTopUpSuccess) {
            if (state.data.state == 1) {
              Navigator.pushNamed(context, '/speedcashTiketTopUpPage');
            } else if (state.data.state == 2) {
              showDialog(
                context: context,
                builder: (_) => BankTransferDialog(state: state),
              );
            }
          } else if (state is RequestTopUpError) {
            showAppToast(context, state.message, ToastType.error);
          }
        },
        child: Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(backgroundColor: kWhite, scrolledUnderElevation: 0),
          body: SingleChildScrollView(
            padding: const .symmetric(vertical: 30, horizontal: 16),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                HeaderSection(title: widget.title, imageUrl: widget.imageUrl),
                const SizedBox(height: 25),
                widget.isBank
                    ? BankSection(controller: controller)
                    : VASection(
                        kodeVA: widget.kodeVA,
                        atasNama: widget.atasNama,
                      ),
                const SizedBox(height: 16),
                Text(
                  widget.isBank
                      ? "Minimal Top up ${CurrencyUtil.formatCurrency(double.tryParse(widget.minimumTopUp) ?? 0)}"
                      : "Biaya Admin ${CurrencyUtil.formatCurrency(double.tryParse(widget.minimumTopUp) ?? 0)}",
                  style: TextStyle(color: kNeutral90),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Panduan',
                  style: TextStyle(
                    color: kNeutral100,
                    fontSize: 16,
                    fontWeight: .w600,
                  ),
                ),
                const SizedBox(height: 8),
                const PanduanSection(),
                const SizedBox(height: 80),
              ],
            ),
          ),
          bottomNavigationBar: widget.isBank
              ? ActionButton(
                  controller: controller,
                  minimumTopUp: widget.minimumTopUp,
                  kodeReseller: kodeReseller,
                  title: widget.title,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
