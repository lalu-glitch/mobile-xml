import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constant_finals.dart';
import '../cubit/request_topup_cubit.dart';
import '../widgets/speedcash_topup_tiket/widget_success_tiket.dart';

class SpeedCashTiketTopUp extends StatelessWidget {
  const SpeedCashTiketTopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: kBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Menunggu Pembayaran',
          style: const TextStyle(
            color: kBlack,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: BlocBuilder<RequestTopUpCubit, RequestTopUpState>(
        builder: (context, state) {
          if (state is RequestTopUpLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kOrange),
            );
          }
          if (state is RequestTopUpSuccess) {
            return SuccessContent(data: state.data);
          }
          if (state is RequestTopUpError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: kRed),
                  const SizedBox(height: 16),
                  Text(state.message),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kWhite),
      child: SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kOrange,
            foregroundColor: kWhite,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // Logic navigasi yang lebih aman (popUntil)
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: const Text(
            "Saya Sudah Transfer",
            style: TextStyle(fontWeight: .w600, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
