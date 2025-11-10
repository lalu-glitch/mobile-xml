import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/bottom_sheet.dart';
import '../../../core/helper/constant_finals.dart';
import '../cubit/balance_cubit.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {},
                          customBorder: const CircleBorder(),
                          child: Icon(Icons.search, color: kWhite),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {},
                          customBorder: const CircleBorder(),
                          child: Stack(
                            children: [
                              Icon(Icons.notifications_none, color: kWhite),
                              Positioned(
                                left: 12,
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: kGreen,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            showCSBottomSheet(context, "Hubungi CS");
                          },
                          customBorder: const CircleBorder(),
                          child: Icon(Icons.headset_mic_rounded, color: kWhite),
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
