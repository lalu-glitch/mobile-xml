import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant_finals.dart';
import '../../../core/utils/bottom_sheet.dart';
import '../../../data/models/user/info_akun.dart';
import '../cubit/unbind_ewallet_cubit.dart';

class WalletCard extends StatelessWidget {
  final Ewallet ewallet;

  const WalletCard({required this.ewallet});

  @override
  Widget build(BuildContext context) {
    final String nama = ewallet.nama;
    final String kodeDompet = ewallet.kodeDompet;
    final int binding = ewallet.binding;
    final String iconUrl = ewallet.icon;

    return BlocBuilder<UnbindEwalletCubit, EwalletState>(
      builder: (context, state) {
        final bool isLoading =
            state is UnbindLoading && state.kodeDompet == kodeDompet;

        return Container(
          width: 300,
          margin: const EdgeInsets.only(right: 8, bottom: 12),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: kNeutral70.withAlpha(15),
                spreadRadius: 1,
                blurRadius: 20,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon dompet
                iconUrl.isNotEmpty
                    ? Image.network(
                        iconUrl,
                        height: 40,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.account_balance_wallet, size: 40),
                      )
                    : const Icon(Icons.account_balance_wallet, size: 40),

                const SizedBox(height: 8),

                // Nama dompet
                Text(
                  nama,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),

                const Spacer(),

                // Tombol bind/unbind
                (binding == 0)
                    ? ElevatedButton(
                        onPressed: () {
                          String routeName;
                          switch (kodeDompet) {
                            case 'SP':
                              routeName = '/speedcashBindingPage';
                              break;
                            case 'NB':
                              routeName = '/'; //<-- menyusul
                              break;
                            default:
                              routeName =
                                  '/'; // <--- kalo gaada walet bakal dilempar ke homepage (case sementara)
                          }
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            routeName,
                            (route) => false,
                            arguments: {'ewallet': ewallet},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Hubungkan',
                          style: Styles.kNunitoMedium.copyWith(
                            color: kWhite,
                            fontSize: Screen.kSize16,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                showUnbindBottomSheet(
                                  context,
                                  () => context
                                      .read<UnbindEwalletCubit>()
                                      .unbindEwallet(kodeDompet),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Unbind',
                              style: Styles.kNunitoMedium.copyWith(
                                color: kWhite,
                                fontSize: Screen.kSize16,
                              ),
                            ),
                            if (isLoading) ...[
                              const SizedBox(width: 8),
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    kWhite,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
