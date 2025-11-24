import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/bottom_sheet.dart';
import '../../../core/helper/constant_finals.dart';
import '../cubit/balance_cubit.dart';

/// kode ini handle buat nampilin welcoming text (selamat 'waktu')
/// dan beberapa action kaya search button, notification button dan cs button.
class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) {
        if (state is BalanceLoading) {
          return const SizedBox(height: 150);
        }
        if (state is BalanceLoaded) {
          return Column(
            crossAxisAlignment: .start,
            children: [
              Padding(
                padding: const .symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          DateTime.now().hour < 11
                              ? 'Selamat Pagi,'
                              : DateTime.now().hour < 15
                              ? 'Selamat Siang,'
                              : DateTime.now().hour < 18
                              ? 'Selamat Sore,'
                              : 'Selamat Malam,',
                          style: TextStyle(color: kWhite, fontSize: kSize16),
                        ),
                        Text(
                          state.data.namauser ?? 'Agen XML',
                          style: TextStyle(color: kWhite, fontSize: kSize20),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisSize: .min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Badge.count(
                            count: 100,
                            maxCount: 99,
                            child: Icon(
                              Icons.notifications_active_rounded,
                              color: kWhite,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showCSBottomSheet(context, "Hubungi CS");
                          },
                          icon: Icon(Icons.headset_mic_rounded, color: kWhite),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Card
              const SizedBox(height: 50),
            ],
          );
        }
        if (state is BalanceError) {
          return const SizedBox(height: 150);
        }
        return SizedBox.shrink();
      },
    );
  }
}
