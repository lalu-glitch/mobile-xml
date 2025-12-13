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
import '../widgets/speedcash_topup/widget_sp_lanjut_button.dart';
import '../widgets/speedcash_topup/widget_sp_panduan.dart';
import '../widgets/speedcash_topup/widget_sp_topup_header_section.dart';
import '../widgets/speedcash_topup/widget_sp_va_section.dart';

class SpeedcashTopUp extends StatefulWidget {
  const SpeedcashTopUp({
    super.key,
    this.isBank = false,
    this.kodeVA = '',
    this.atasNama = '',
    required this.imageUrl,
    required this.title,
    required this.minimumTopUp,
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
  late final TextEditingController _controller;
  String? _kodeReseller;

  late final String _formattedMinText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    final infoState = context.read<InfoAkunCubit>().state;
    if (infoState is InfoAkunLoaded) {
      _kodeReseller = infoState.data.data.kodeReseller;

      context.read<PanduanTopUpCubit>().fetchPanduan(
        _kodeReseller ?? '',
        widget.title ?? '',
      );
    }

    final double minVal = double.tryParse(widget.minimumTopUp) ?? 0;
    final String formattedVal = CurrencyUtil.formatCurrency(minVal);

    if (widget.isBank) {
      _formattedMinText = "Minimal Top up $formattedVal";
    } else {
      _formattedMinText = "Biaya Admin $formattedVal";
    }
  }

  void _handleStateListener(BuildContext context, RequestTopUpState state) {
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestTopUpCubit, RequestTopUpState>(
      listener: _handleStateListener,
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          backgroundColor: kWhite,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  HeaderSection(title: widget.title, imageUrl: widget.imageUrl),
                  const SizedBox(height: 25),

                  if (widget.isBank)
                    BankSection(controller: _controller)
                  else
                    VASection(kodeVA: widget.kodeVA, atasNama: widget.atasNama),

                  const SizedBox(height: 16),

                  Text(_formattedMinText, style: TextStyle(color: kNeutral90)),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  const Text(
                    'Panduan',
                    style: TextStyle(
                      color: kNeutral100,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const PanduanSection(),
                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: widget.isBank
            ? SafeArea(
                child: Padding(
                  padding: const .fromLTRB(16, 0, 16, 16),
                  child: BlocBuilder<RequestTopUpCubit, RequestTopUpState>(
                    builder: (context, state) {
                      if (state is RequestTopUpLoading) {
                        return Container(
                          margin: const .symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            color: kNeutral50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: kWhite,
                              strokeWidth: 3,
                            ),
                          ),
                        );
                      }
                      return ActionButtonSpeedcash(
                        controller: _controller,
                        minimumTopUp: widget.minimumTopUp,
                        kodeReseller: _kodeReseller,
                        title: widget.title,
                      );
                    },
                  ),
                ),
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
